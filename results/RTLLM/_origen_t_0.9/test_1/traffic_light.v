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
			state <= s1_red;
		end
		else begin
			case (state)
				idle:	state <= s1_red;
				s1_red:	state <= (cnt == 3) ? s3_green : s1_red;
				s2_yellow:	state <= (cnt == 3) ? s1_red : s2_yellow;
				s3_green:	state <= (cnt == 3) ? s2_yellow : s3_green;
				default:	state <= idle;
			endcase
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 10;
		end
		else begin
			if (pass_request && red)
				cnt <= 10;
			else if (!green && p_green)
				cnt <= 60;
			else if (!yellow && p_yellow)
				cnt <= 5;
			else if (!red && p_red)
				cnt <= 10;
			else
				cnt <= cnt - 1;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			p_red <= 0;
			p_yellow <= 0;
			p_green <= 0;
		end
		else begin
			p_red <= red;
			p_yellow <= yellow;
			p_green <= green;
		end
	end

	assign clock = cnt;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			red <= 0;
			yellow <= 0;
			green <= 0;
		end
		else begin
			red <= p_red;
			yellow <= p_yellow;
			green <= p_green;
		end
	end

endmodule