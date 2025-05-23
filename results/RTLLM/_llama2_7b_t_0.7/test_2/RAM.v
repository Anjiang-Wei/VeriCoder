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

// RAM Array Definition
reg [DEPTH - 1 : 0] RAM [2**WIDTH-1:0];

// Always Blocks
always @(posedge clk or negedge rst_n) begin
	// Reset Memory Locations on Reset
	if (!rst_n) begin
		RAM <= {8{1'b0}};
	end else begin
		// Write Operation
		if (write_en) begin
			RAM[write_addr] = write_data;
		end
		// Read Operation
		if (read_en) begin
			read_data <= RAM[read_addr];
		end else begin
			read_data <= {8{1'b0}}; // Reset Read Data on Non-Read Operations
		end
	end
end

// Output Ports
output reg [5:0] read_data;