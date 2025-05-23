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

// Define the RAM array
reg [DEPTH - 1 : 0] RAM [2**WIDTH-1:0];

// Initialize all memory locations to 0
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		RAM <= 0;
	end else begin
		if (write_en) begin
			RAM[write_addr] <= write_data;
		end
		if (read_en) begin
			read_data <= RAM[read_addr];
		end
	end
end

// Output ports
output reg [5:0] read_data;