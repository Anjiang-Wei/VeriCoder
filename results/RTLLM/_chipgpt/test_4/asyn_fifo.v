dual_port_RAM 
	#(.DEPTH(DEPTH), .WIDTH(WIDTH)) 
	(
	.wclk(wclk), 
	.rclk(rclk), 
	.wrstn(~wrstn),
	.rrstn(~rrstn), 
	.winc(winc),
	.renc(1), //write enable active low
	.rdinc(rinc),
	.wdata(wdata),
	.rdata(rdata)
    ); 
 
//pointer buffer
wire [ADDR_WIDTH-1:0] wptr; 
wire rptr; 
assign wptr = waddr_bin[ADDRESS-1:0]; //address is width-bit binary
always @(posedge wclk) begin
	if (wrstn && ~wrstn) wptr <= 0;
	else if (!wrstn && winc) wptr <= {wptr[ADDR_WIDTH-1:1], wptr[0] + 1'b1}; //use binary for gray code conversion
end
assign rptr = raddr_bin[ADDRESS-1:0]; //address is width-bit binary
always @(posedge rclk) begin
	if (rrstn && ~rrstn) rptr <= 0;
	else if (!rrstn && rinc) rptr <= {rptr[ADDR_WIDTH-1:1], rptr[0] + 1'b1}; //use binary for gray code conversion
end

//pointer syncer
wire [ADDR_WIDTH-1:0] wptr_syn; 
wire [ADDR_WIDTH-1:0] rptr_syn; 
assign wptr_syn = wptr[ADDR_WIDTH-1:1]; //use binary for gray code conversion
assign rptr_syn = rptr[ADDR_WIDTH-1:1];   //use binary for gray code conversion
always @* begin
	wire [ADDR_WIDTH-1:0] wptr_next; 
	wire [ADDR_WIDTH-1:0] rptr_next; 
	wptr_syn = {wptr[ADDR_WIDTH-2:0], wptr_syn}; //use binary for gray code conversion
	rptr_syn = {rptr[ADDR_WIDTH-2:0], rptr_syn};   //use binary for gray code conversion
	if (wptr == rptr_next) begin  //when next is equal to the current pointer then there's no need to shift left anymore and it will stop at 0
		wptr_next = wptr;
	end
	else if (wptr != rptr_next) begin //use binary for gray code conversion
		wptr_next = {wptr[ADDR_WIDTH-2:1], wptr[0] ^ rptr_syn}; //convert to gray code and use "xor" with the next pointer value (rptr_next) to reduce glitches and guarantee proper synchronization of the read and write pointers
	end
end 
assign {wptr, wptr_syn} = {wptr_next[ADDR_WIDTH-1:0], wptr_next[0]}; //use binary for gray code conversion

//full/empty logic
wire [ADDR_WIDTH-1:0] wptr_buff; 
wire rptr_buff; 
assign wptr_buff = {wptr, wptr_syn}; //use binary for gray code conversion
assign rptr_buff = {rptr, rptr_syn};   //use binary for gray code conversion
always @* begin
	if (wptr[ADDR_WIDTH-1] === ~(rptr_buff[ADDR_WIDTH-1:0])) wfull = 1;
	else wfull = 0;
end
assign rempty = rptr == wptr_next; //when wptr is equal to rptr then the FIFO is empty

endmodule