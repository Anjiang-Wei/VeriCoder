module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

	// Data register to store the input data
	reg [3:0] data_reg;
	// Enable data register to store the input enable signal
	reg data_en_reg;
	// Control registers for enable signal synchronization
	reg en_clap_one, en_clap_two;

	// Update data register on the positive edge of clk_a or reset
	always @(posedge clk_a or negedge arstn) begin
		if (!arstn)
			data_reg <= 4'b0;
		else
			data_reg <= data_in;
	end

	// Update enable data register on the positive edge of clk_a or reset
	always @(posedge clk_a or negedge arstn) begin
		if (!arstn)
			data_en_reg <= 1'b0;
		else
			data_en_reg <= data_en;
	end

	// Update enable control registers on the positive edge of clk_b or reset
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

	// Assign output data on the positive edge of clk_b or reset
	always @(posedge clk_b or negedge brstn) begin
		if (!brstn)
			dataout <= 4'b0;
		else if (en_clap_two)
			dataout <= data_reg;
	end

endmodule