module RAM (
	input clk,
	input rst_n,
	
	input write_en,
	input [7:0]write_addr,
	input [5:0]write_data,
	
	input read_en,
	input [7:0]read_addr,
	output reg [5:0]read_data
);

	// Parameter definition
	parameter WIDTH = 6;
	parameter DEPTH = 8;

	// RAM array declaration
	reg [WIDTH-1:0] RAM [2**WIDTH-1:0];

	// Write operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Initialize RAM to 0 on reset
			for (integer i = 0; i < 2**WIDTH; i = i + 1) begin
				RAM[i] <= 0;
			end
		end else if (write_en) begin
			// Write data to RAM
			RAM[write_addr] <= write_data;
		end
	end

	// Read operation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			// Clear read_data on reset
			for (integer i = 0; i < WIDTH; i = i + 1) begin
				read_data[i] <= 0;
			end
		end else if (read_en) begin
			// Read data from RAM
			read_data <= RAM[read_addr];
		end else begin
			// Clear read_data if read_en is not active
			read_data <= 0;
		end
	end

endmodule