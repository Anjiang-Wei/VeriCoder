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
              
    reg [7:0] cnt;   // 8-bit internal counter
    reg [1:0] state; // State register
    reg [1:0] next_state; // Next state register
    reg p_red, p_yellow, p_green; // Previous state signals
    
    assign clock = cnt; // Assign the internal counter to the clock output

    // State Transition Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle; // Reset state to idle
        end else begin
            state <= next_state; // Update to next state
        end
    end

    // Next State Logic and Counter Adjustments
    always @(*) begin
        // Default assignments
        next_state = state;
        
        case(state)
            idle: begin
                red = 0; yellow = 0; green = 0; // Reset lights
                next_state = s1_red; // Go to red state
            end
            
            s1_red: begin
                red = 1; yellow = 0; green = 0; // Red light ON
                if (cnt == 8'd0) next_state = s3_green; // Transition to green
            end
            
            s2_yellow: begin
                red = 0; yellow = 1; green = 0; // Yellow light ON
                if (cnt == 8'd0) next_state = s1_red; // Transition to red
            end
            
            s3_green: begin
                red = 0; yellow = 0; green = 1; // Green light ON
                if (cnt == 8'd0) next_state = s2_yellow; // Transition to yellow
            end
            
            default: next_state = idle; // Fallback to idle state
        endcase
    end

    // Counting Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10; // Set initial count to 10
        end else if (pass_request && (green || yellow)) begin
            if (cnt > 8'd10) begin
                cnt <= 8'd10; // Shorten the green time if remaining time is greater than 10
            end
        end else if (!green && p_green) begin
            cnt <= 8'd60; // Load initial count for green light
        end else if (!yellow && p_yellow) begin
            cnt <= 8'd5; // Load initial count for yellow light
        end else if (!red && p_red) begin
            cnt <= 8'd10; // Load initial count for red light
        end else if (cnt > 0) begin
            cnt <= cnt - 1; // Decrement counter
        end
    end

    // Previous State Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

endmodule