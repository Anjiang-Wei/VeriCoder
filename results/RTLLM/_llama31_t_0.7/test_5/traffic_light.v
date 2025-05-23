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
	
	reg[7:0] cnt; // internal counter for timing purposes
	reg[1:0] state; // current state of the traffic light controller
	wire p_red, p_yellow, p_green; // next values for the red, yellow, and green signals
	
	always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n) begin
			state <= idle;
			cnt <= 10'd0;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end
		else if (state == idle) state <= s1_red; // transition to s1_red immediately
		else if (state == s1_red) begin
			if (cnt < 3'd3) cnt <= cnt + 1'd1;
			else state <= s3_green;
		end
		else if (state == s2_yellow) begin
			if (cnt < 3'd3) cnt <= cnt + 1'd1;
			else state <= s1_red;
		end
		else if (state == s3_green) begin
			if (cnt < 3'd3) cnt <= cnt + 1'd1;
			else state <= s2_yellow;
		end
	end
	
	always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n || pass_request && green) cnt <= 10'd0; // reset counter on reset or pass request and green
		else if (!green && p_green) cnt <= 60'd0; // count down from 60 when green is off and previous green was on
		else if (!yellow && p_yellow) cnt <= 5'd0; // count down from 5 when yellow is off and previous yellow was on
		else if (!red && p_red) cnt <= 10'd0; // count down from 10 when red is off and previous red was on
		else cnt <= cnt - 1'd1; // normal counting logic
	end
	
	assign clock = cnt;
	
	always @(posedge clk or negedge rst_n)
	begin
		if (!rst_n) begin
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end
		else begin
			case (state)
				idle: begin p_red <= 1'b1; p_yellow <= 1'b0; p_green <= 1'b0; end
				s1_red: begin p_red <= 1'b1; p_yellow <= 1'b0; p_green <= 1'b0; end
				s2_yellow: begin p_red <= 1'b0; p_yellow <= 1'b1; p_green <= 1'b0; end
				s3_green: begin p_red <= 1'b0; p_yellow <= 1'b0; p_green <= 1'b1; end
			endcase
		end
	end
	
	assign red = p_red;
	assign yellow = p_yellow;
	assign green = p_green;
endmodule