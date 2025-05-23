```verilog
	reg [7:0]cnt;
	reg [1:0]state, p_state;
	reg red_prev, yellow_prev, green_prev;

	always @(posedge clk or negedge rst_n)
	begin
		if (~rst_n)
		begin
			cnt <= 8'd10;
			state <= idle;
			red_prev <= 1'b0;
			yellow_prev <= 1'b0;
			green_prev <= 1'b0;
		end
		else
		begin
			if (pass_request && green)
			begin
				cnt <= 8'd10;
			end
			else if (~green && green_prev)
			begin
				cnt <= 8'd60;
			end
			else if (~yellow && yellow_prev)
			begin
				cnt <= 8'd5;
			end
			else if (~red && red_prev)
			begin
				cnt <= 8'd10;
			end
			else
			begin
				cnt <= cnt - 1'b1;
			end
		end
	end
	
	always @(posedge clk or negedge rst_n)
	begin
		if (~rst_n)
		begin
			state <= idle;
		end
		else
		begin
			case (state)
				idle:
				begin
					state <= s1_red;
				end
				s1_red:
				begin
					if (cnt == 8'd3)
					begin
						state <= s3_green;
					end
					else
					begin
						state <= s1_red;
					end
				end
				s2_yellow:
				begin
					if (cnt == 8'd3)
					begin
						state <= s1_red;
					end
					else
					begin
						state <= s2_yellow;
					end
				end
				s3_green:
				begin
					if (cnt == 8'd3)
					begin
						state <= s2_yellow;
					end
					else
					begin
						state <= s3_green;
					end
				end
			endcase
		end
	end
	
	always @(posedge clk or negedge rst_n)
	begin
		if (~rst_n)
		begin
			red <= 1'b0;
			yellow <= 1'b0;
			green <= 1'b0;
		end
		else
		begin
			case (state)
				idle:
				begin
					red_prev <= 1'b0;
					yellow_prev <= 1'b0;
					green_prev <= 1'b0;
				end
				s1_red:
				begin
					red_prev <= 1'b1;
					yellow_prev <= 1'b0;
					green_prev <= 1'b0;
				end
				s2_yellow:
				begin
					red_prev <= 1'