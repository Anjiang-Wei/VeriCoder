reg en_clap_one, en_clap_two;
always @(posedge clk_b or negedge brstn) begin
	if (~brstn) begin
		en_clap_one <= 1'b0;
		en_clap_two <= 1'b0;
	end else begin
		en_clap_one <= en_data_reg;
		en_clap_two <= en_clap_one;
	end
end