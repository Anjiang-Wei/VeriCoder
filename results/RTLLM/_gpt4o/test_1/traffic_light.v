module traffic_light
	(
		input rst_n, 
		input clk, 
		input pass_request,
		output wire [7:0] clock,
		output reg red,
		output reg yellow,
		output reg green
	);
	
	parameter idle = 2'd0,
			  s1_red = 2'd1,
			  s2_yellow = 2'd2,
			  s3_green = 2'd3;
	
	reg [1:0] state, next_state;
	reg [7:0] cnt, next_cnt;
	reg p_red, p_yellow, p_green; // Previous state signals for red, yellow, green
	
	// Assign internal counter to the 'clock' output
	assign clock = cnt;
	
	// State transition logic (sequential always block)
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= idle;
			cnt <= 8'b0;
		end else begin
			state <= next_state;
			cnt <= next_cnt;
		end
	end
	
	// Next state logic and counter update (combinational always block)
	always @(*) begin
		// Default values
		next_state = state;
		next_cnt = cnt - 1;
		
		case (state)
			idle: begin
				next_state = s1_red; // Start from red state
				next_cnt = 8'd10;    // Initialize red light duration
			end
			
			s1_red: begin
				if (cnt == 0) begin
					next_state = s3_green; // Transition to green
					next_cnt = 8'd60;      // Start with 60 clock cycles for green
				end
			end
			
			s2_yellow: begin
				if (cnt == 0) begin
					next_state = s1_red; // Transition back to red
					next_cnt = 8'd10;    // Set red light duration
				end
			end
			
			s3_green: begin
				if (cnt == 0) begin
					next_state = s2_yellow; // Transition to yellow
					next_cnt = 8'd5;        // Set yellow light duration
				end else if (pass_request && cnt > 10) begin
					next_cnt = 8'd10; // Shorten green to 10 cycles if requested
				end
			end
			
			default: begin
				next_state = idle; // Ensure safe state
			end
		endcase
	end
	
	// Output logic for red, yellow, and green signals
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			red <= 1'b0;
			yellow <= 1'b0;
			green <= 1'b0;
			p_red <= 1'b0;
			p_yellow <= 1'b0;
			p_green <= 1'b0;
		end else begin
			// Update previous light states
			p_red <= red;
			p_yellow <= yellow;
			p_green <= green;
			
			// Set red, yellow, green outputs based on state
			case (state)
				s1_red: begin
					red <= 1'b1;
					yellow <= 1'b0;
					green <= 1'b0;
				end
				
				s2_yellow: begin
					red <= 1'b0;
					yellow <= 1'b1;
					green <= 1'b0;
				end
				
				s3_green: begin
					red <= 1'b0;
					yellow <= 1'b0;
					green <= 1'b1;
				end
				
				default: begin
					red <= 1'b0;
					yellow <= 1'b0;
					green <= 1'b0;
				end
			endcase
		end
	end
endmodule