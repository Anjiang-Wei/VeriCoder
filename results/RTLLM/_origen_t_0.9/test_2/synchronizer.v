module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

reg [3:0] data_reg;
reg       en_data_reg;
reg       en_clap_one;
reg       en_clap_two;
reg [1:0] counter;

always @(posedge clk_a or negedge arstn) begin
	if (!arstn) begin
		data_reg <= 4'b0;
		en_data_reg <= 1'b0;
	end else begin
		data_reg <= data_in;
		en_data_reg <= data_en;
	end
end

always @(posedge clk_b or negedge brstn) begin
	if (!brstn) begin
		en_clap_one <= 1'b0;
		en_clap_two <= 1'b0;
		counter <= 2'b0;
	end else begin
		en_clap_one <= en_data_reg;
		en_clap_two <= en_clap_one;
		if (en_clap_two) begin
			if (counter == 2'b11)
				counter <= 2'b0;
			else
				counter <= counter + 1'b1;
		end else begin
			counter <= 2'b0;
		end
	end
end

always @(posedge clk_b or negedge brstn) begin
	if (!brstn) begin
		dataout <= 4'b0;
	end else if (en_clap_two && (counter >= 2'b01)) begin
		dataout <= data_reg;
	end
end

endmodule