module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn  ,
	input		[3:0]	data_in	,
	input               data_en,

	output reg  [3:0] 	dataout
);

	// Data Register
	reg	[3:0]		data_reg;
	always @(posedge clk_a or negedge arstn) begin
		if (!arstn) begin
			data_reg <= 4'b0;
		end else begin
			data_reg <= data_in;
		end
	end

	// Enable Data Register
	reg		data_en_reg;
	always @(posedge clk_a or negedge arstn) begin
		if (!arstn) begin
			data_en_reg <= 1'b0;
		end else begin
			data_en_reg <= data_en;
		end
	end

	// Enable Control Registers
	reg	[1:0]		en_clap_one_reg;
	reg	[1:0]		en_clap_two_reg;
	always @(posedge clk_b or negedge brstn) begin
		if (!brstn) begin
			en_clap_one_reg <= 2'b00;
			en_clap_two_reg <= 2'b00;
		end else begin
			en_clap_one_reg <= {en_clap_two_reg[0], data_en_reg};
			en_clap_two_reg <= en_clap_one_reg;
		end
	end

	// Output Assignment
	always @(posedge clk_b or negedge brstn) begin
		if (!brstn) begin
			dataout <= 4'b0;
		end else begin
			if (en_clap_two_reg[1]) begin
				dataout <= data_reg;
			end else begin
				dataout <= dataout;
			end
		end
	end

endmodule