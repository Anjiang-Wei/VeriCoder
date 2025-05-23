```verilog
	reg[7:0] cnt = 8'd0;
	reg [1:0] state = idle;
	reg p_red = 0, p_yellow = 0, p_green = 0;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 8'd10;
			state <= s1_red;
		end else begin
			case (state)
				s1_red: begin
					if (cnt == 8'd3) begin
						state <= s3_green;
					end else begin
						state <= s1_red;
					end
				end
				s2_yellow: begin
					if (cnt == 8'd3) begin
						state <= s1_red;
					end else begin
						state <= s2_yellow;
					end
				end
				s3_green: begin
					if (cnt == 8'd3) begin
						state <= s2_yellow;
					end else begin
						state <= s3_green;
					end
				end
				default: begin
					state <= s1_red;
				end
			endcase
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 8'd10;
			red <= 1;
			yellow <= 0;
			green <= 0;
		end else begin
			case (state)
				s1_red: begin
					cnt <= cnt - 1;
					if (pass_request && green) begin
						cnt <= 8'd10;
					end else if (!green && p_green) begin
						cnt <= 8'd60;
					end else if (!yellow && p_yellow) begin
						cnt <= 8'd5;
					end else if (!red && p_red) begin
						cnt <= 8'd10;
					end
				end
				s2_yellow: begin
					cnt <= cnt - 1;
					if (cnt == 8'd3) begin
						state <= s1_red;
					end else begin
						state <= s2_yellow;
					end
				end
				s3_green: begin
					cnt <= cnt - 1;
					if (cnt == 8'd3) begin
						state <= s2_yellow;
					end else begin
						state <= s3_green;
					end
				end
				default: begin
					cnt <= cnt - 1;
					state <= s1_red;
				end
			endcase
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			red <= 1;
			yellow <= 0;
			green <= 0;
		end else begin
			p_red <= red;
			p_yellow <= yellow;
			p_green <= green;
			if (green) begin
				red <= 0;
				yellow <= 0;