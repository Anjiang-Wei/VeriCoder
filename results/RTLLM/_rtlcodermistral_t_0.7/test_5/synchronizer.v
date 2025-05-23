```verilog
	//Data Register
	reg [3:0] data_reg;
	always @(posedge clk_a, negedge arstn) begin
		if (~arstn) begin
			data_reg <= 4'b0;
		end else begin
			data_reg <= data_in;
		end
	end
	
	//Enable Data Register
	reg [3:0] en_data_reg;
	always @(posedge clk_a, negedge arstn) begin
		if (~arstn) begin
			en_data_reg <= 4'b0;
		end else begin
			en_data_reg <= data_en;
		end
	end
	
	//Enable Control Registers
	reg en_clap_one;
	reg en_clap_two;
	always @(posedge clk_b, negedge brstn) begin
		if (~brstn) begin
			en_clap_one <= 1'b0;
			en_clap_two <= 1'b0;
		end else begin
			en_clap_one <= en_data_reg;
			en_clap_two <= en_clap_one;
		end
	end
	
	//Output Assignment
	always @(posedge clk_b, negedge brstn) begin
		if (~brstn) begin
			dataout <= 4'b0;
		end else if (en_clap_two) begin
			dataout <= data_reg;
		end
	end

endmodule