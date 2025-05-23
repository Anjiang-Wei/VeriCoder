reg [7:0] cnt;
		reg [1:0] state;
		reg p_red, p_yellow, p_green;

    always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n) begin
				state <= idle;
				cnt <= 8'd10;
			end
			else
				case(state)
					idle: begin
						state <= s1_red;
					end
					s1_red: begin
						if (cnt == 8'd3) begin
							state <= s3_green;
						end
						else
							state <= s1_red;
					end
					s2_yellow: begin
						if (cnt == 8'd3) begin
							state <= s1_red;
						end
						else
							state <= s2_yellow;
					end
					s3_green: begin
						if (cnt == 8'd3) begin
							state <= s2_yellow;
						end
						else
							state <= s3_green;
					end
				endcase
		end

    always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n) 
				cnt <= 8'd10;
			else
				case(state)
					idle: begin
						cnt <= 8'd10;
					end
					s1_red: begin
						if (pass_request && green)
							cnt <= 8'd10;
						else if (!green && p_green)
							cnt <= 8'd60;
						else
							cnt <= cnt - 8'd1;
					end
					s2_yellow: begin
						if (!yellow && p_yellow)
							cnt <= 8'd5;
						else
							cnt <= cnt - 8'd1;
					end
					s3_green: begin
						if (!green && p_green)
							cnt <= 8'd10;
						else
							cnt <= cnt - 8'd1;
					end
				endcase
		end

    always @(posedge clk or negedge rst_n)
		begin
			if (!rst_n) begin
				red <= 1'b0;
				yellow <= 1'b0;
				green <= 1'b1;
			end
			else begin
				red <= p_red;
				yellow <= p_yellow;
				green <= p_green;
			end
		end

	assign clock = cnt;

endmodule