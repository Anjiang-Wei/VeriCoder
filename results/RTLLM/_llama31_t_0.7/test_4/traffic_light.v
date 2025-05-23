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
	wire p_red, p_yellow, p_green;

	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			cnt <= 8'h10; // Reset counter to 16
			state <= idle; // Reset state machine to idle
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else begin
			case (state)
				idle: begin
					if (cnt == 8'h00) begin
						cnt <= 8'h03; // Set counter to 3 for s1_red state
						state <= s1_red;
						p_red <= 1'b1;
						p_yellow <= 1'b0;
						p_green <= 1'b0;
					end else begin
						cnt <= cnt - 1'd1;
					end
				end

				s1_red: begin
					if (cnt == 8'h02) begin
						cnt <= 8'h60; // Set counter to 96 for s3_green state
						state <= s3_green;
						p_red <= 1'b0;
						p_yellow <= 1'b0;
						p_green <= 1'b1;
					end else begin
						cnt <= cnt - 1'd1;
					end
				end

				s2_yellow: begin
					if (cnt == 8'h03) begin
						cnt <= 8'h05; // Set counter to 5 for s1_red state
						state <= s1_red;
						p_red <= 1'b0;
						p_yellow <= 1'b1;
						p_green <= 1'b0;
					end else begin
						cnt <= cnt - 1'd1;
					end
				end

				s3_green: begin
					if (cnt == 8'h03) begin
						cnt <= 8'h05; // Set counter to 5 for s2_yellow state
						state <= s2_yellow;
						p_red <= 1'b0;
						p_yellow <= 1'b1;
						p_green <= 1'b0;
					end else begin
						cnt <= cnt - 1'd1;
					end
				end

				default: begin
					cnt <= 8'h00; // Invalid state, reset counter to 0
				end
			endcase
		end
	endmodule

	always @(posedge clk or negedge rst_n)
	if (~rst_n) begin
		cnt <= 8'h10;
	end else if (pass_request && green) begin
		cnt <= 8'hA; // Set counter to 10 for pedestrian request
	end else if (!green && p_green) begin
		cnt <= 8'h60; // Set counter to 96 for s3_green state
	end else if (!yellow && p_yellow) begin
		cnt <= 8'h05; // Set counter to 5 for s2_yellow state
	end else if (!red && p_red) begin
		cnt <= 8'h10; // Set counter to 16 for s1_red state
	end else begin
		cnt <= cnt - 1'd1;
	end

	assign clock = cnt;

	always @(posedge clk or negedge rst_n)
	if (~rst_n) begin
		p_red <= 1'b0;
		p_yellow <= 1'b0;
		p_green <= 1'b0;
	end else if (green && pass_request) begin
		p_red <= 1'b0;
		p_yellow <= 1'b0;
		p_green <= 1'b0; // Reset pedestrian request
	end else if (!green && p_green) begin
		p_red <= 1'b0;
		p_yellow <= 1'b0;
		p_green <= 1'b1; // Set green signal for s3_green state
	end else if (!yellow && p_yellow) begin
		p_red <= 1'b0;
		p_yellow <= 1'b1;
		p_green <= 1'b0; // Set yellow signal for s2_yellow state
	end else if (!red && p_red) begin
		p_red <= 1'b1;
		p_yellow <= 1'b0;
		p_green <= 1'b0; // Set red signal for s1_red state
	end

	assign red = p_red;
	assign yellow = p_yellow;
	assign green = p_green;