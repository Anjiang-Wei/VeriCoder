always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt <= 10;
			state <= idle;
		end
		else begin
			case (state)
				idle: begin
					cnt <= 10;
					state <= s1_red;
				end
				s1_red: begin
					cnt <= cnt - 1;
					if(cnt == 2) begin
						cnt <= 10;
						state <= s3_green;
					end
					else begin
						state <= s1_red;
					end
				end
				s2_yellow: begin
					cnt <= cnt - 1;
					if(cnt == 2) begin
						cnt <= 10;
						state <= s1_red;
					end
					else begin
						state <= s2_yellow;
					end
				end
				s3_green: begin
					cnt <= cnt - 1;
					if(cnt == 2) begin
						cnt <= 10;
						state <= s2_yellow;
					end
					else begin
						state <= s3_green;
					end
				end
			endcase
		end
	end