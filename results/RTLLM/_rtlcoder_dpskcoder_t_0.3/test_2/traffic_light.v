module traffic_light
    (
		input rst_n, 
      input clk, 
      input pass_request,
		  output wire[7:0]clock,
      output reg red,
		  output reg yellow,
		  output reg green
    );
	
	parameter 	idle = 2'd0,
				s1_red = 2'd1,
				s2_yellow = 2'd2,
				s3_green = 2'd3;
				
	reg[7:0] cnt;
	reg[1:0] state;
	reg p_red, p_yellow, p_green;
	
	assign clock = cnt;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end
		else begin
			case (state)
				idle: begin
					state <= s1_red;
					cnt <= 8'd10;
					p_red <= 1'b1;
					p_yellow <= 1'b0;
					p_green <= 1'b0;
				end
				s1_red: begin
					if (cnt == 8'd3) begin
						state <= s2_yellow;
						cnt <= 8'd5;
						p_red <= 1'b0;
						p_yellow <= 1'b1;
						p_green <= 1'b0;
					end
				end
				s2_yellow: begin
					if (cnt == 8'd3) begin
						state <= s3_green;
						cnt <= 8'd60;
						p_red <= 1'b0;
						p_yellow <= 1'b0;
						p_green <= 1'b1;
					end
				end
				s3_green: begin
					if (cnt == 8'd3) begin
						state <= s1_red;
						cnt <= 8'd10;
						p_red <= 1'b1;
						p_yellow <= 1'b0;
						p_green <= 1'b0;
					end
				end
			endcase
		end
	end
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 8'd10;
		end
		else begin
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
	
	always @(posedge clk or negedge rst_n) begin
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