dual_port_RAM	#(
	.WIDTH (WIDTH),
	.DEPTH (DEPTH)
)(
	.wclk (wclk), 
	.rclk (rclk),   
	.wrstn (wrstn),
	.rrstn (rrstn),  
	.wen ({winc}),    //write enable
	.rdenc (rinc),     //read enable
	.wdata(wdata[WIDTH-1:0]), 
	.ren({rinc}),       //read data output
	.addr_bin({wptr_next, wptr_next_syn}),   //write pointer
	.dout (ram_mem[DEPTH*WIDTH-1:0])    //read data input
);
 
genvar i;
generate for(i=0;i<ADDR_WIDTH;i=i+1) begin: RAM_block
	if(wptr_next[i] == rptr_syn[i]) wfull = 1'b1;   //write full signal. Indicates if the FIFO is full and cannot accept further write operations.
	else wfull = 1'b0;
	if(rptr_syn[i] == {wptr_next{i+1}}) rempty = 1'b1;   //read empty signal. Indicates if the FIFO is empty and cannot provide any data for read operations.
	else remempty = 1'b0;
end
endgenerate
assign rdata = {rptr_syn, remempty, wfull};

//pointer synchronizer
always @(posedge wclk) begin
	if(!wrstn) wptr <= wptr_next;    //write pointer incremented on the positive edge of the write clock (wclk).
end
always @(negedge rclk or posedge wrstn) begin
	if(!wrstn) rptr_syn <= rptr;
	else begin
		rptr_syn[i] <= rptr_next[i]; //read pointer incremented on the positive edge of the read clock (rclock).
		rptr_syn[i+1] <= {rptr_syn[0:i], rptr_next[ADDR_WIDTH-1]};
	end
end 

//pointer buffer.
always @(posedge wclk or negedge wrstn) begin
	if(!wrstn) wptr_buff <= wptr;
	else begin
		wptr_buff <= wptr_next;
		wptr_buff[i+1] <= {wptr_buff[0:i], wptr_next};  //last bit is negated.
	end
end
always @(posedge rclk or negedge rrstn) begin
	if(!rrstn) rptr_buff <= rptr;
	else begin
		rptr_buff <= rptr_next;
		rptr_buff[i+1] <= {rptr_buff[0:i], rptr_next};  //last bit is negated.
	end
end

endmodule