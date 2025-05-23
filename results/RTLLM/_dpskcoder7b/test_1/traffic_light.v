reg [7:0] cnt = 8'd10;
	reg [1:0] state = idle;
	reg [1:0] next_state;
	reg p_red, p_yellow, p_green;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			cnt <= 8'd10;
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
	
	always @(state or cnt or pass_request or red or green) begin
		case(state)
			idle: begin
				cnt <= 8'd10;
				next_state <= s1_red;
			end
			s1_red: begin
				red <= 1'b1;
				cnt <= cnt - 8'd1;
				if (cnt == 8'd0) begin
					next_state <= s3_green;
				end else begin
					next_state <= s1_red;
				end
			end
			s2_yellow: begin
				yellow <= 1'b1;
				cnt <= cnt - 8'd1;
				if (cnt == 8'd0) begin
					next_state <= s1_red;
				end else begin
					next_state <= s2_yellow;
				end
			end
			s3_green: begin
				green <= 1'b1;
				cnt <= cnt - 8'd1;
				if (cnt == 8'd0) begin
					next_state <= s2_yellow;
				end else begin
					next_state <= s3_green;
				end
			end
		endcase
	end
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 8'd10;
		end else begin
			case(state)
				s1_red: begin
					if (!red && p_red) begin
						cnt <= 8'd60;
					end
				end
				s2_yellow: begin
					if (!yellow && p_yellow) begin
						cnt <= 8'd5;
					end
				end
				s3_green: begin
					if (!green && p_green) begin
						cnt <= 8'd10;
					end
				end
				default: begin
					cnt <= cnt - 8'd1;
				end
			endcase
		end
	end
	
	assign clock = cnt;

endmodule