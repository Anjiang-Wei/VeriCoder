module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);
	// Data registers
	reg [3:0] data_reg;
	reg en_data_reg;
	reg en_clap_one;
	reg en_clap_two;

	// Data register update
	always @(posedge clk_a or negedge arstn) begin
		if (!arstn) begin
			data_reg <= 4'b0; // Reset data register
		end else begin
			data_reg <= data_in; // Update data register
		end
	end

	// Enable data register update
	always @(posedge clk_a or negedge arstn) begin
		if (!arstn) begin
			en_data_reg <= 1'b0; // Reset enable register
		end else begin
			en_data_reg <= data_en; // Update enable register
		end
	end

	// Enable control registers
	always @(posedge clk_b or negedge brstn) begin
		if (!brstn) begin
			en_clap_one <= 1'b0; // Reset enable control registers
			en_clap_two <= 1'b0;
		end else begin
			en_clap_one <= en_data_reg; // Update enable control registers
			en_clap_two <= en_clap_one;
		end
	end

	// Output assignment
	always @(posedge clk_b or negedge brstn) begin
		if (!brstn) begin
			dataout <= 4'b0; // Reset output
		end else if (en_clap_two) begin
			dataout <= data_reg; // Update output
		end
	end
endmodule