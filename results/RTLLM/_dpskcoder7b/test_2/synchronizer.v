module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

// Registers for input data and enable signal
reg [3:0] data_reg;
reg data_en_reg;

// Registers for enable control
reg en_clap_one;
reg en_clap_two;

// Data register update on clk_a
always @(posedge clk_a or negedge arstn) begin
	if (!arstn)
		data_reg <= 4'b0;
	else
		data_reg <= data_in;
end

// Data enable register update on clk_a
always @(posedge clk_a or negedge arstn) begin
	if (!arstn)
		data_en_reg <= 1'b0;
	else
		data_en_reg <= data_en;
end

// Enable control registers update on clk_b
always @(posedge clk_b or negedge brstn) begin
	if (!brstn) begin
		en_clap_one <= 1'b0;
		en_clap_two <= 1'b0;
	end
	else begin
		en_clap_one <= data_en_reg;
		en_clap_two <= en_clap_one;
	end
end

// Output assignment on clk_b
always @(posedge clk_b or negedge brstn) begin
	if (!brstn)
		dataout <= 4'b0;
	else if (en_clap_two)
		dataout <= data_reg;
end

endmodule