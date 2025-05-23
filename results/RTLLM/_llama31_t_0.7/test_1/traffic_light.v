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
		if (~rst_n) begin
			state <= idle;
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else if (state == s3_green && cnt < 8'd10) begin
			cnt <= 8'd60;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
			state <= idle;
		end else if (state == s2_yellow && cnt < 8'd5) begin
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
			state <= s1_red;
		end else if (state == s1_red && cnt < 8'd3) begin
			cnt <= 8'd60;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b1;
			state <= s3_green;
		end else if (cnt > 0 && pass_request == 1'b1 && green == 1'b1) begin
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
			state <= idle;
		end else if (cnt > 0 && cnt < 8'd60 && green == 1'b0 && p_green == 1'b1) begin
			cnt <= 8'd60;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b1;
		end else if (cnt > 0 && cnt < 8'd5 && yellow == 1'b0 && p_yellow == 1'b1) begin
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
			state <= s1_red;
		end else if (cnt > 0 && cnt < 8'd3 && red == 1'b0 && p_red == 1'b1) begin
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else begin
			cnt <= cnt - 1;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			clock <= 8'd0;
		end else if (cnt < 8'd10 && pass_request == 1'b1 && green == 1'b1) begin
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else if (cnt > 0 && cnt < 8'd60 && green == 1'b0 && p_green == 1'b1) begin
			cnt <= 8'd60;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b1;
		end else if (cnt > 0 && cnt < 8'd5 && yellow == 1'b0 && p_yellow == 1'b1) begin
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else if (cnt > 0 && cnt < 8'd3 && red == 1'b0 && p_red == 1'b1) begin
			cnt <= 8'd10;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else begin
			clock <= cnt;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			green <= 1'b0;
			yellow <= 1'b0;
			red <= 1'b0;
		end else if (cnt < 8'd10 && pass_request == 1'b1 && green == 1'b1) begin
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else if (cnt > 0 && cnt < 8'd60 && green == 1'b0 && p_green == 1'b1) begin
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b1;
		end else if (cnt > 0 && cnt < 8'd5 && yellow == 1'b0 && p_yellow == 1'b1) begin
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else if (cnt > 0 && cnt < 8'd3 && red == 1'b0 && p_red == 1'b1) begin
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else begin
			green <= p_green;
			yellow <= p_yellow;
			red <= p_red;
		end
	end

endmodule