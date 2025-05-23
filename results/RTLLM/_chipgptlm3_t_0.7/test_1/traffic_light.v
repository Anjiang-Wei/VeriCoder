reg[1:0] state, state_next;
		reg[7:0] cnt, cnt_next;
		reg p_red, p_yellow, p_green;
		
		always @ (posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				state <= idle;
				cnt <= 8'd0;
				red <= 1'b0;
				yellow <= 1'b0;
				green <= 1'b0;
				p_red <= 1'b0;
				p_yellow <= 1'b0;
				p_green <= 1'b0;
			end else begin
				state <= state_next;
				cnt <= cnt_next;
				red <= p_red;
				yellow <= p_yellow;
				green <= p_green;
			end
		end
		
		always @ (state or cnt) begin
			case (state)
				idle: begin
					p_red = 1'b0;
					p_yellow = 1'b0;
					p_green = 1'b0;
					state_next = s1_red;
				end
				s1_red: begin
					p_red = 1'b0;
					p_yellow = 1'b0;
					p_green = 1'b0;
					if (cnt == 8'd3) begin
						state_next = s3_green;
					end else begin
						state_next = s1_red;
					end
				end
				s2_yellow: begin
					p_red = 1'b0;
					p_yellow = 1'b0;
					p_green = 1'b0;
					if (cnt == 8'd3) begin
						state_next = s1_red;
					end else begin
						state_next = s2_yellow;
					end
				end
				s3_green: begin
					p_red = 1'b0;
					p_yellow = 1'b0;
					p_green = 1'b0;
					if (cnt == 8'd3) begin
						state_next = s2_yellow;
					end else begin
						state_next = s3_green;
					end
				end
			endcase
		end
		
		always @ (posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				cnt <= 8'd10;
			end else begin
				if (cnt == 8'd0) begin
					if (pass_request && green) begin
						cnt <= 8'd10;
					end else if (!green && p_green) begin
						cnt <= 8'd60;
					end else if (!yellow && p_yellow) begin
						cnt <= 8'd5;
					end else if (!red && p_red) begin
						cnt <= 8'd10;
					end else begin
						cnt <= cnt - 1;
					end
				end
			end
		end
		
		assign clock = cnt;
	endmodule