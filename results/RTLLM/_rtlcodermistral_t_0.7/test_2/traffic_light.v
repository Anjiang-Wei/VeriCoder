```verilog
	reg [7:0]cnt;
	reg [1:0] state;
	reg p_red, p_yellow, p_green;
	
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 8'd10;
			state <= idle;
		end
		else begin
			case (state)
				idle: begin
					red <= 1'b1;
					yellow <= 1'b0;
					green <= 1'b0;
					state <= s1_red;
				end
				s1_red: begin
					red <= 1'b1;
					yellow <= 1'b0;
					green <= 1'b0;
					if (cnt == 8'd3) begin
						state <= s3_green;
					end
				end
				s2_yellow: begin
					red <= 1'b0;
					yellow <= 1'b1;
					green <= 1'b0;
					if (cnt == 8'd3) begin
						state <= s1_red;
					end
				end
				s3_green: begin
					red <= 1'b0;
					yellow <= 1'b0;
					green <= 1'b1;
					if (cnt == 8'd3) begin
						state <= s2_yellow;
					end
				end
			endcase
			if (pass_request && green) begin
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
	
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 8'd10;
			state <= idle;
		end
		else begin
			case (state)
				idle: begin
					p_red <= 1'b0;
					p_yellow <= 1'b0;
					p_green <= 1'b0;
				end
				s1_red: begin
					p_red <= 1'b1;
					p_yellow <= 1'b0;
					p_green <= 1'b0;
				end
				s2_yellow: begin
					p_red <= 1'b0;
					p_yellow <= 1'b1;
					p_green <= 1'b0;
				end
				s3_green: begin
					p_red <= 1'b0;
					p_yellow <= 1'b0;
					p_green <= 1'b1;
				end
			endcase
		end
	end
	
	assign clock = cnt;
	assign red = p_red;
	assign yellow = p_yellow;
	assign green = p