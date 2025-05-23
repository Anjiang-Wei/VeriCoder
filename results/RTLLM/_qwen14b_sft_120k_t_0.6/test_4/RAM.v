module RAM (
	input clk,
	input rst_n,
	
	input write_en,
	input [7:0] write_addr,
	input [5:0] write_data,
	
	input read_en,
	input [7:0] read_addr,
	output reg [5:0] read_data
);
	parameter WIDTH = 6;
	parameter DEPTH = 8;
	
	// RAM array with depth of 8 and width of 6 bits, initialized to 0
	reg [5:0] RAM [0:2**WIDTH-1];
	
	// Write operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset all memory locations to 0
			integer i;
			for (i = 0; i < 2**WIDTH; i = i + 1)
				RAM[i] <= 6'b0;
		end else if (write_en) begin
			// Write data to specified address
			RAM[write_addr] <= write_data;
		end
	end
	
	// Read operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset read data to 0 on reset
			read_data <= 6'b0;
		end else if (read_en) begin
			// Read data from specified address
			read_data <= RAM[read_addr];
		end else begin
			// Clear read data if not reading
			read_data <= 6'b0;
		end
	end
endmodule