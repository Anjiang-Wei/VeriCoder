module dual_port_RAM (
	wclk,
	wenc,
	waddr,
	wdata,
	rclk,
	renc,
	raddr,
	rdata
);
	input 			wclk;
	input 			wenc;
	input [ADDR_WIDTH-1:0]	waddr;
	input [WIDTH-1:0]	wdata;
	input 			rclk;
	input 			renc;
	input [ADDR_WIDTH-1:0]	raddr;
	output 			[WIDTH-1:0]	rdata;

	reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

	always @(posedge wclk)
		if (wenc)
			RAM_MEM[waddr] <= wdata;

	assign rdata = (renc) ? RAM_MEM[raddr] : {WIDTH{1'b0}};

endmodule