```verilog
	reg [3:0]cnt;
	reg [7:0]dout_reg;
	reg valid_reg;
	
	always @(posedge clk) begin
		if(!rst_n) begin
			cnt <= 4'd0;
			dout_reg <= 8'd0;
			valid_reg <= 1'b0;
		end
		else begin
			if(din_valid) begin
				cnt <= cnt + 1;
				if(cnt == 4'd8) begin
					dout_reg <= {dout_reg[6:0], din_serial};
					cnt <= 4'd0;
					if(valid_reg) begin
						dout_valid <= 1'b0;
					end
					valid_reg <= 1'b1;
					dout_parallel <= dout_reg;
				end
			end
		end
	end
	
endmodule