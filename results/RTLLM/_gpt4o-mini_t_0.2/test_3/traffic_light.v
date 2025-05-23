module traffic_light
    (
        input rst_n, 
        input clk, 
        input pass_request,
        output wire[7:0] clock,
        output reg red,
        output reg yellow,
        output reg green
    );
    
    parameter   idle = 2'd0,
                s1_red = 2'd1,
                s2_yellow = 2'd2,
                s3_green = 2'd3;

    reg [7:0] cnt; // 8-bit counter
    reg [1:0] state; // Current state
    reg [1:0] next_state; // Next state
    reg p_red, p_yellow, p_green; // Previous states of the signals

    assign clock = cnt; // Assign internal counter to output
    
    // State transition and output control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle; // Reset to initial state
            cnt <= 8'd10; // Set counter to initial value
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                idle: begin
                    state <= s1_red; // Move to red state
                end
                s1_red: begin
                    red <= 1; yellow <= 0; green <= 0; // Red light on
                    if (cnt == 8'd0) begin
                        next_state <= s3_green; // Switch to green state
                        cnt <= 60; // Reset counter for green
                    end else begin
                        next_state <= s1_red; // Stay in red state
                    end
                end
                s2_yellow: begin
                    red <= 0; yellow <= 1; green <= 0; // Yellow light on
                    if (cnt == 8'd0) begin
                        next_state <= s1_red; // Switch to red state
                        cnt <= 10; // Reset counter for red
                    end else begin
                        next_state <= s2_yellow; // Stay in yellow state
                    end
                end
                s3_green: begin
                    red <= 0; yellow <= 0; green <= 1; // Green light on
                    if (cnt == 8'd0) begin
                        next_state <= s2_yellow; // Switch to yellow state
                        cnt <= 5; // Reset counter for yellow
                    end else begin
                        next_state <= s3_green; // Stay in green state
                    end
                end
            endcase
            // Update state
            if (cnt == 0) state <= next_state;
        end
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10; // Reset counter
            p_red <= 0; p_yellow <= 0; p_green <= 0; // Reset previous states
        end else begin
            // Handle pedestrian button and adjust counter if required
            if (pass_request && (green && cnt > 8'd10)) begin
                cnt <= 8'd10; // Set counter to 10 if green and request is active
            end else if (green && !p_green) begin
                cnt <= 8'd60; // Reset counter when transitioning from green
            end else if (yellow && !p_yellow) begin
                cnt <= 8'd5; // Reset counter when transitioning from yellow
            end else if (red && !p_red) begin
                cnt <= 8'd10; // Reset counter when transitioning from red
            end else if (cnt > 0) begin
                cnt <= cnt - 1; // Decrement counter
            end

            // Save the previous states
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;
        end
    end

endmodule