Please complete the Verilog code below and return the complete module code directly:
```verilog
module dual_port_RAM #(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input 				wclk,
	input 				rclk,
	input 				wenc,
	input [ADDR_WIDTH-1:0]	waddr,
	input [WIDTH-1:0]	wdata,
	input 				renc,
	input [ADDR_WIDTH-1:0]	raddr,
	output 				[WIDTH-1:0]	rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk)
begin
	if (wenc)
		RAM_MEM[waddr] <= wdata;
end

assign rdata = RAM_MEM[raddr];

endmodule