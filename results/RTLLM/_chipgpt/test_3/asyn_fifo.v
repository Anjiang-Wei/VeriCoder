dual_port_RAM m0(  //Dual port RAM
	.clk(wclk),
	.en({wrstn,wrinc}),
	.addr({{1{ADDRESS_WIDTH+1}},wrdata}),
	.dout(rdata)
);

dual_port_RAM m1(  //Dual port RAM
	.clk(rclk),
	.en({rrstn,rinc}),
	.addr({{1{ADDRESS_WIDTH+1}},rdata}),
	.dout(wdata)
);

//Write Pointer
wire [ADDR_WIDTH-1:0] wptr;
assign wptr = m0.addr[0][3:2];
assign {wrstn,wrinc} = ~wrstn&wrptr[ADDR_WIDTH-1:2]; //Next word position is the bitwise negation of last word + 1 bit.
//Read Pointer
wire [ADDR_WIDTH-1:0] rptr;
assign rptr = m1.addr[0][3:2];   //Last word position
assign {rrstn,rinc} = ~rrstn&rptr[ADDR_WIDTH-1:2];//Next word position is the bitwise negation of last word + 1 bit.

//Full and Empty Conditions
wire full;
assign wfull = wdata[0] ^ (wptr[ADDR_WIDTH-1:2] ^ {1{ADDRESS_WIDTH}}); //if the write pointer is one cycle ahead of the read pointer, then this signal will be 1.
assign rempty = rptr == wptr;//if there's no difference between the two pointers, then this signal will be 1
assign full = {wrstn,wrinc}&wfull | {rrstn,rinc}&rempty;   //If the write pointer is one cycle ahead of the read pointer and at the same time if there's no difference between the two pointers,then this signal will be 1.
assign rdata = m0.dout[23:0];//Read from last word in dual-port RAM.
assign wfull = {wrstn,wrinc}&wfull | {rrstn,rinc}&rempty;   //If the write pointer is one cycle ahead of the read pointer and at the same time if there's no difference between the two pointers,then this signal will be 1.
assign rdata = m1.dout[23:0];//Read from last word in dual-port RAM.

endmodule