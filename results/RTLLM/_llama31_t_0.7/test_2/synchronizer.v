module synchronizer(
	input 				clk_a, // Clock signal A used for synchronous operations.
	input 				clk_b, // Clock signal B used for synchronous operations.
	input 				arstn, // Active-low reset signal A. Defined as 0 for reset and 1 for reset signal inactive.
	input				brstn   ,// Active-low reset signal B. Defined as 0 for reset and 1 for reset signal inactive.
	input		[3:0]	data_in, // Input data signal of size 4 bits.
	input               data_en, // Input enable signal that controls the selection operation.

	output reg [3:0] 	dataout // Output data signal of size 4 bits.
);

// Data Register
reg [3:0] data_reg;

always @(posedge clk_a or negedge arstn)
begin
	if (!arstn) begin
		data_reg <= 'b0;
	end else begin
		data_reg <= data_in;
	end
end

// Enable Data Register
reg enable_en_data;

always @(posedge clk_a or negedge arstn)
begin
	if (!arstn) begin
		enable_en_data <= 1'b0;
	end else begin
		enable_en_data <= data_en;
	end
end

// Enable Control Registers
reg [2:0] en_clap_one, en_clap_two;

always @(posedge clk_b or negedge brstn)
begin
	if (!brstn) begin
		en_clap_one <= 'b0;
		en_clap_two <= 'b0;
	end else begin
		en_clap_two <= en_clap_one;
		if (enable_en_data == 1'b1) begin
			en_clap_one <= enable_en_data;
		end
	end
end

// Output Assignment
always @(posedge clk_b or negedge brstn)
begin
	if (!brstn) begin
		dataout <= 'b0;
	end else begin
		if (en_clap_two == 1'b1) begin
			dataout <= data_reg;
		end
	end
end

endmodule // synchronizer