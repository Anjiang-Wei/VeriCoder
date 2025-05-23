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
	
	reg [2:0] state, next_state;
	reg [7:0] cnt, next_cnt;
	
	parameter 	idle = 3'd0,
				s1_red = 3'd1,
				s2_yellow = 3'd2,
				s3_green = 3'd3;
	
	always @(posedge clk or negedge rst_n)
		if (!rst_n) 
			state <= idle;
		else 
			state <= next_state;
	
	always @(posedge clk or negedge rst_n)
		if (!rst_n) 
			cnt <= 8'd60;
		else 
			cnt <= next_cnt;
	
	always @(state or cnt or pass_request)
	begin
		case(state)
			idle: 
				if (pass_request)
					next_state = s3_green;
				else
					next_state = s1_red;
			s1_red: 
				if (cnt == 8'd0)
					next_state = s3_green;
				else
					next_state = s1_red;
			s2_yellow: 
				if (cnt == 8'd0)
					next_state = s1_red;
				else
					next_state = s2_yellow;
			s3_green: 
				if (cnt == 8'd0)
					next_state = s2_yellow;
				else
					next_state = s3_green;
			default: next_state = idle;
		endcase
	end
	
	always @(state or cnt or pass_request)
	begin
		case(state)
			idle: 
				next_cnt = 8'd60;
			s1_red: 
				next_cnt = (pass_request & green) ? 8'd10 : 8'd60;
			s2_yellow: 
				next_cnt = (cnt == 8'd5) ? 8'd5 : cnt - 1'b1;
			s3_green: 
				next_cnt = (cnt == 8'd60) ? 8'd10 : cnt - 1'b1;
			default: next_cnt = 8'd60;
		endcase
	end
	
	always @(posedge clk or negedge rst_n)
		if (!rst_n) 
		begin
			red <= 1'b0;
			yellow <= 1'b0;
			green <= 1'b0;
		end
		else
		begin
			red <= (state == s1_red);
			yellow <= (state == s2_yellow);
			green <= (state == s3_green);
		end
	
	assign clock = cnt;
	
endmodule