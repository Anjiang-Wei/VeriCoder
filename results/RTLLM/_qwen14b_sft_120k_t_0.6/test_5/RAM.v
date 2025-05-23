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

	// RAM array
	reg [5:0] RAM [2**WIDTH-1:0];

	// Write operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset RAM array to 0
			for (int i = 0; i < 2**WIDTH; i = i + 1) begin
				RAM[i] <= 6'b000000;
			end
		end
		else if (write_en) begin
			// Write data to RAM at write_addr
			RAM[write_addr] <= write_data;
		end
	end

	// Read operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Reset read_data to 0 on reset
			read_data <= 6'b000000;
		end
		else if (read_en) begin
			// Read data from RAM at read_addr
			read_data <= RAM[read_addr];
		end
		else begin
			// Clear read_data when not reading
			read_data <= 6'b000000;
		end
	end

endmodule