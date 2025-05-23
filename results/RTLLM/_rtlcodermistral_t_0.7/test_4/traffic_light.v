```verilog
	reg [7:0] cnt;
	reg [1:0] state;
	reg p_red, p_yellow, p_green;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 10;
		end
		else begin
			if (pass_request && green) begin
				cnt <= 10;
			end
			else if (green) begin
				cnt <= 60;
			end
			else if (yellow) begin
				cnt <= 5;
			end
			else if (red) begin
				cnt <= 10;
			end
			else begin
				cnt <= cnt - 1;
			end
		end
	end
	
	assign clock = cnt;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			red <= 0;
			yellow <= 0;
			green <= 0;
		end
		else begin
			case (state)
				idle: begin
					red <= 1;
					state <= s1_red;
				end
				s1_red: begin
					if (cnt == 3) begin
						state <= s3_green;
					end
					else begin
						state <= s1_red;
					end
				end
				s2_yellow: begin
					if (cnt == 3) begin
						state <= s1_red;
					end
					else begin
						state <= s2_yellow;
					end
				end
				s3_green: begin
					if (cnt == 3) begin
						state <= s2_yellow;
					end
					else begin
						state <= s3_green;
					end
				end
			endcase
		end
	end
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			p_red <= 0;
			p_yellow <= 0;
			p_green <= 0;
		end
		else begin
			case (state)
				idle: begin
					p_red <= 1;
					p_yellow <= 0;
					p_green <= 0;
				end
				s1_red: begin
					p_red <= 1;
					p_yellow <= 0;
					p_green <= 0;
				end
				s2_yellow: begin
					p_red <= 0;
					p_yellow <= 1;
					p_green <= 0;
				end
				s3_green: begin
					p_red <= 0;
					p_yellow <= 0;
					p_green <= 1;
				end
			endcase
		end
	end
	
	assign red = p_red;
	assign yellow = p_yellow;
	assign green = p_green;
	
endmodule