reg[2:0] state, next_state;
	reg[7:0] cnt, next_cnt;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			cnt <= 8'd10;
		end else begin
			state <= next_state;
			cnt <= next_cnt;
		end
	end
	
	always @(*) begin
		case (state)
			idle: begin
				next_state = s1_red;
				next_cnt = 8'd10;
			end
			s1_red: begin
				if (cnt == 8'd0) begin
					next_state = s3_green;
					next_cnt = 8'd60;
				end else begin
					next_state = s1_red;
					next_cnt = cnt - 8'd1;
				end
			end
			s2_yellow: begin
				if (cnt == 8'd0) begin
					next_state = s1_red;
					next_cnt = 8'd10;
				end else begin
					next_state = s2_yellow;
					next_cnt = cnt - 8'd1;
				end
			end
			s3_green: begin
				if (cnt == 8'd0) begin
					next_state = s2_yellow;
					next_cnt = 8'd5;
				end else begin
					next_state = s3_green;
					next_cnt = cnt - 8'd1;
				end
			end
		endcase
	end
	
	always @(posedge clk or negedge rst_n) begin
		case (state)
			s1_red: begin
				red <= 1'b1;
				yellow <= 1'b0;
				green <= 1'b0;
			end
			s2_yellow: begin
				red <= 1'b0;
				yellow <= 1'b1;
				green <= 1'b0;
			end
			s3_green: begin
				red <= 1'b0;
				yellow <= 1'b0;
				green <= 1'b1;
			end
			default: begin
				red <= 1'b0;
				yellow <= 1'b0;
				green <= 1'b0;
			end
		endcase
	end
	
	assign clock = cnt;
	
endmodule