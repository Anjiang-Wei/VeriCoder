reg[1:0] state;
	reg p_red, p_yellow, p_green;
	reg[7:0] cnt;

	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
			cnt <= 8'd10;
		end
		else begin
			case (state)
				idle: begin
					p_red <= 1'b1;
					p_yellow <= 1'b0;
					p_green <= 1'b0;
					if (cnt == 8'd0) begin
						state <= s1_red;
					end
					else begin
						cnt <= cnt - 1;
					end
				end
				s1_red: begin
					p_red <= 1'b0;
					p_yellow <= 1'b0;
					p_green <= 1'b0;
					if (cnt == 8'd3) begin
						state <= s3_green;
					end
					else if (pass_request && green) begin
						cnt <= 8'd10;
					end
					else begin
						cnt <= cnt - 1;
					end
				end
				s2_yellow: begin
					p_red <= 1'b0;
					p_yellow <= 1'b1;
					p_green <= 1'b0;
					if (cnt == 8'd3) begin
						state <= s1_red;
					end
					else if (pass_request && green) begin
						cnt <= 8'd10;
					end
					else begin
						cnt <= cnt - 1;
					end
				end
				s3_green: begin
					p_red <= 1'b0;
					p_yellow <= 1'b0;
					p_green <= 1'b1;
					if (cnt == 8'd3) begin
						state <= s2_yellow;
					end
					else if (pass_request && green) begin
						cnt <= 8'd10;
					end
					else begin
						cnt <= cnt - 1;
					end
				end
			endcase
		end
	end

	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 8'd10;
		end
		else begin
			if (!rst_n) begin
				cnt <= 8'd10;
			end
			else if (pass_request && green) begin
				cnt <= 8'd10;
			end
			else if (!green && p_green) begin
				cnt <= 8'd60;
			end
			else if (!yellow && p_yellow) begin
				cnt <= 8'd5;
			end
			else if (!red && p_red) begin
				cnt <= 8'd10;
			end
			else begin
				cnt <= cnt - 1;
			end
		end
	end

	assign clock = cnt;

	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			red <= 1'b0;
			yellow <= 1'b0;
			green <= 1'b0;
		end
		else begin
			red <= p_red;
			yellow <= p_yellow;
			green <= p_green;
		end
	end

endmodule