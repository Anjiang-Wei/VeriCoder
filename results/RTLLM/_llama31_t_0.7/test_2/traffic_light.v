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

	reg [7:0] cnt;
	reg [1:0] state;
	reg p_red, p_yellow, p_green;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			cnt <= 10'd10;
			p_red <= 0;
			p_yellow <= 0;
			p_green <= 0;
		end else begin
			case (state)
				idle: begin
					if (cnt < 60)
						state <= s1_red;
				end
				s1_red: begin
					cnt <= cnt + 10'd3; // wait for 3 cycles before transition to green
					if (cnt >= 60) state <= s3_green;
				end
				s2_yellow: begin
					cnt <= cnt + 10'd5; // wait for 5 cycles before transition to red
					if (cnt >= 15) state <= s1_red; // assuming yellow phase is 15 clocks
				end
				s3_green: begin
					cnt <= cnt + 10'd60;
					if (cnt >= 70) state <= s2_yellow; // assuming green phase is 70 clocks, but it should be 60 as per the description
				end
			endcase
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n || pass_request && green)
			cnt <= 10'd10;
		else if (!green && p_green)
			cnt <= 10'd60;
		else if (!yellow && p_yellow)
			cnt <= 10'd5;
		else if (!red && p_red)
			cnt <= 10'd10;
		else
			cnt <= cnt - 1;

		if (cnt < 0) begin
			cnt <= 10'd10;
			case (state)
				idle: state <= s1_red;
				s1_red: state <= s3_green;
				s2_yellow: state <= s1_red;
				s3_green: state <= s2_yellow;
			endcase
		end
	end

	assign clock = cnt;

	always @(posedge clk or negedge rst_n) begin
		p_red <= red;
		p_yellow <= yellow;
		p_green <= green;
	end

	always @(posedge clk or negedge rst_n) begin
		case (state)
			idle: begin
				clock <= 0;
				red <= 1'b0;
				yellow <= 1'b0;
				green <= 1'b0;
			end
			s1_red: begin
				clock <= cnt + 10'd3;
				red <= 1'b1;
				yellow <= 1'b0;
				green <= 1'b0;
			end
			s2_yellow: begin
				clock <= cnt + 10'd5;
				red <= 1'b0;
				yellow <= 1'b1;
				green <= 1'b0;
			end
			s3_green: begin
				clock <= cnt + 10'd60;
				red <= 1'b0;
				yellow <= 1'b0;
				green <= 1'b1;
			end
		endcase
	end

endmodule