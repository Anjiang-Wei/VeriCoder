wire[ADDR_WIDTH-1:0] wptr;  //write pointer
wire[ADDR_WIDTH-1:0] rptr;   //read pointer
reg[WIDTH-1:0]	wdata_tmp;  //temp register for writing data to fifo
reg[WIDTH-1:0]	rdata_tmp;   //temp register for reading data from fifo
reg wptr_sync, rptr_sync;    //register for synchronizing write and read pointer

//dual port ram module
wire [DEPTH-1:0,WIDTH-1:0] waddr;
wire [DEPTH-1:0,WIDTH-1:0] raddr; 
reg[WIDTH-1:0] wdata_rd; //read data for dual-port ram
reg[DEPTH-1:0] wdata_wr; //write data for dual-port ram
wire [WIDTH-1:0] rdata;    //dual port ram output

//register wptr and rptr as binary numbers to be converted into gray code.
reg[ADDR_WIDTH+1:0]	waddr_bin; 
reg[ADDR_WIDTH+1:0]	rptr_bin;  
always @(posedge wclk or posedge wrstn) begin
	if(!wrstn) wptr <= #1 {0,ADDR_WIDTH'b0}; //reset write pointer to 0
	else wptr <= #1 waddr_bin + rptr_bin;   //update write pointer based on previous write and read pointers
end
always @(posedge rclk or posedge rrstn) begin
	if(!rrstn) rptr <= #1 {0,ADDR_WIDTH'b0}; //reset read pointer to 0
	else rptr <= #1 raddr_bin + wptr_sync;   //update read pointer based on previous write and read pointers
end

//gray code conversion of wptr and rptr to binary numbers
always @* begin
	wptr_sync = ~wptr[ADDR_WIDTH];  //get most significant bit(1) for wptr
	rptr_sync = {ADDR_WIDTH{~rptr[ADDR_WIDTH]}}; //get all bits(0 or 1) for rptr
end

//register buffer of wptr and rptr.
reg [ADDR_WIDTH+1:0]	wptr_buff, rptr_buff;
always @* begin
	if(!wrstn && !rrstn) begin //resynchronize write and read pointer for determining full or empty condition
		wptr_buff = wptr;
		rptr_buff = rptr;
	end
	else if(winc) wptr_buff <= #1 wptr + 1'b0;   //update write pointer when enable write is active
	else wptr_buff <= wptr;              //keep the previous value of write pointer for synchronizing read and write pointers
	if(rinc) rptr_buff <= #1 rptr + 1'b0;     //update read pointer when enable read is active
	else rptr_buff <= rptr;
end

//signal wfull will be 1 if the most significant bit of the write pointer is equal to the negation of remaining bits(the last bit) of the read pointer.
assign wfull = ~wptr[ADDR_WIDTH] & rptr_sync[ADDR_WIDTH];

//signal rempty will be 1 if the write pointer and read pointer are equal.
assign rempty=rptr==wptr;

//output port of asynfifo module is used to store data from dual-port ram.
assign rdata = {rptr[ADDR_WIDTH],{rptr_buff[DEPTH+1:0]}};

//signal wdata will be the next input value when enable write is active.
always @* begin
	wdata_wr <= #1 wdata;
	if(~wrstn && rinc) //store data to the fifo when enble read is inactive and enable write is active
		wdata_wr <= wdata_tmp;
end

//register buffer of next input value.
reg[WIDTH-1:0] wdata_tmp;
always @* begin
	if(!wrstn && rinc) begin //store data to the fifo when enble read is inactive and enable write is active
		wdata_tmp = wdata;  
	end
	else if(winc) begin //update next input value of wdata with one less than current input value
		wdata_tmp <= {WIDTH{~wdata[WIDTH-1]}}&wdata;
	end
	else wdata_tmp = wdata;  //keep the last input value as next input value of wdata
end

//fifo register for the dual port ram.
reg [WIDTH-1:0] rdata_temp;
always @* begin
	rdata_temp <= #1 rdata;   //store the data in fifo(dual-port ram) when enable write is active
	if(!rrstn && !winc) rdata_temp <= rdata_tmp;  //store the last input value of dual-port ram as next value in fifo when enble read is inactive and disable write is active
end

//fifo register for the dual port ram output.
reg [WIDTH-1:0] rdata_rd;
always @* begin
	rdata_rd <= #1 rdata_temp;   //store the data from fifo as next input value of dual-port ram when enable read is active
	if(!wrstn && !rrstn) rdata_rd <= rdata;  //output the last value of dual-port ram as next output value of dual-port ram when enble write is inactive and disable read is inactive
end

//signal rdata will be used to connect with flip-flop to make an active low circuit.
assign rdata_tmp = {WIDTH{~rdata[WIDTH-1]}}; //store last value of dual-port ram as next input value when disable write is inactive

endmodule