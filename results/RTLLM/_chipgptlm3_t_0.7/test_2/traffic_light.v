reg[1:0] state, next_state;
		reg[7:0] cnt;
		reg p_red, p_yellow, p_green;
		assign clock = cnt;
		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				cnt <= 10;
				state <= idle;
				red <= 1'b0;
				yellow <= 1'b0;
				green <= 1'b0;
			end else begin
				state <= next_state;
				red <= p_red;
				yellow <= p_yellow;
				green <= p_green;
			end
		end
		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				cnt <= 10;
			end else begin
				if (state == idle) begin
					cnt <= 10;
				end else if (state == s1_red) begin
					cnt <= cnt - 1;
					if (cnt == 3) begin
						next_state <= s3_green;
						p_red <= 1'b0;
						p_yellow <= 1'b0;
						p_green <= 1'b1;
					end else if (cnt == 0) begin
						next_state <= idle;
						p_red <= 1'b1;
						p_yellow <= 1'b0;
						p_green <= 1'b0;
					end else begin
						next_state <= s1_red;
					end
				end else if (state == s2_yellow) begin
					cnt <= cnt - 1;
					if (cnt == 3) begin
						next_state <= s1_red;
						p_red <= 1'b0;
						p_yellow <= 1'b1;
						p_green <= 1'b0;
					end else if (cnt == 0) begin
						next_state <= idle;
						p_red <= 1'b1;
						p_yellow <= 1'b0;
						p_green <= 1'b0;
					end else begin
						next_state <= s2_yellow;
					end
				end else if (state == s3_green) begin
					cnt <= cnt - 1;
					if (cnt == 3) begin
						next_state <= s2_yellow;
						p_red <= 1'b0;
						p_yellow <= 1'b1;
						p_green <= 1'b0;
					end else if (cnt == 0) begin
						next_state <= idle;
						p_red <= 1'b1;
						p_yellow <= 1'b0;
						p_green <= 1'b0;
					end else begin
						next_state <= s3_green;
					end
				end else begin
					next_state <= state;
				end
			end
		end
		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				cnt <= 10;
			end else begin
				if (state == idle) begin
					cnt <= 10;
				end else if (state == s1_red) begin
					if (pass_request && green) begin
						cnt <= 10;
					end else if (!green && p_green) begin
						cnt <= 60;
					end else begin
						cnt <= cnt - 1;
					end
				end else if (state == s2_yellow) begin
					if (pass_request && green) begin
						cnt <= 10;
					end else if (!green && p_green) begin
						cnt <= 60;
					end else if (!yellow && p_yellow) begin
						cnt <= 5;
					end else begin
						cnt <= cnt - 1;
					end
				end else if (state == s3_green) begin
					if (pass_request && green) begin
						cnt <= 10;
					end else if (!green && p_green) begin
						cnt <= 60;
					end else if (!red && p_red) begin
						cnt <= 10;
					end else begin
						cnt <= cnt - 1;
					end
				end else begin
					cnt <= cnt - 1;
				end
			end
		end
endmodule