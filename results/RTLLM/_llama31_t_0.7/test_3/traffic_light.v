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
	wire p_red, p_yellow, p_green;
	wire state;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else begin
			case (state)
				idle: state <= s1_red;
				s1_red: if (cnt < 3) p_red <= 1'b1; else state <= s3_green;
				s2_yellow: if (cnt < 3) p_yellow <= 1'b1; else state <= s1_red;
				s3_green: if (cnt < 60) p_green <= 1'b1; else if (pass_request && green) cnt <= 8'd10; else state <= s2_yellow;
			endcase
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n || pass_request && green) cnt <= 8'd10;
		else if (~green && p_green) cnt <= 8'd60;
		else if (~yellow && p_yellow) cnt <= 8'd5;
		else if (~red && p_red) cnt <= 8'd10;
		else cnt <= cnt - 1;
	end

	assign clock = cnt;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else begin
			red <= p_red;
			yellow <= p_yellow;
			green <= p_green;
		end
	end

endmodule