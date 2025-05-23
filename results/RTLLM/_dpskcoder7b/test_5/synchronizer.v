module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

// registers for data_in and data_en
reg [3:0] data_reg;
reg data_en_reg;
reg [1:0] en_clap;

// register data_in on rising edge of clk_a
always @(posedge clk_a or negedge arstn) begin
	if (!arstn)
		data_reg <= 4'b0;
	else
		data_reg <= data_in;
end

// register data_en on rising edge of clk_a
always @(posedge clk_a or negedge arstn) begin
	if (!arstn)
		data_en_reg <= 1'b0;
	else
		data_en_reg <= data_en;
end

// control registers for enable
always @(posedge clk_b or negedge brstn) begin
	if (!brstn)
		en_clap <= 2'b0;
	else
		en_clap <= {en_clap[0], data_en_reg};
end

// output assignment on rising edge of clk_b
always @(posedge clk_b or negedge brstn) begin
	if (!brstn)
		dataout <= 4'b0;
	else if (en_clap[1])
		dataout <= data_reg;
end

endmodule