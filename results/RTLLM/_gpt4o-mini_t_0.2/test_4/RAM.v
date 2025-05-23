module RAM (
	input clk,
	input rst_n,
	
	input write_en,
	input [2:0] write_addr, // Depth of 8 = 3 bits (2^3 = 8)
	input [5:0] write_data,
	
	input read_en,
	input [2:0] read_addr, // Depth of 8 = 3 bits (2^3 = 8)
	output reg [5:0] read_data
);

	parameter WIDTH = 6;
	parameter DEPTH = 8;

	// RAM array
	reg [WIDTH-1:0] RAM [0:DEPTH-1];

	// Write operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// On reset, initialize all memory to 0
			integer i;
			for (i = 0; i < DEPTH; i = i + 1) begin
				RAM[i] <= 6'b000000; 
			end
		end else if (write_en) begin
			// Write data to RAM at the specified address
			RAM[write_addr] <= write_data;
		end
	end

	// Read operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			read_data <= 6'b000000; // Clear read_data on reset
		end else if (read_en) begin
			// Read data from RAM at the specified address
			read_data <= RAM[read_addr];
		end else begin
			// If read enable is not active, clear read_data
			read_data <= 6'b000000;
		end
	end

endmodule