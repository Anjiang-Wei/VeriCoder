module traffic_light
    (
        input  rst_n,         // Active-low reset signal
        input  clk,           // Clock signal
        input  pass_request,  // Pedestrian request button
        output wire [7:0] clock, // Counter output
        output reg red,       // Red light indicator
        output reg yellow,    // Yellow light indicator
        output reg green      // Green light indicator
    );

    // State parameters
    parameter idle      = 2'd0,
              s1_red    = 2'd1,
              s2_yellow = 2'd2,
              s3_green  = 2'd3;

    reg [1:0] state, next_state;   // Current state and next state
    reg [7:0] cnt;                 // Internal counter
    reg p_red, p_yellow, p_green;  // Previous state of the lights

    // Assign the counter to the clock output
    assign clock = cnt;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;  // Reset to the idle state
        end else begin
            state <= next_state;  // Update to the next state
        end
    end

    // Next state logic and output light control
    always @(*) begin
        // Default behavior
        next_state = state;
        red = 0;
        yellow = 0;
        green = 0;

        case (state)
            idle: begin
                red = 1;  // Default to red in idle
                cnt = 0;  // Reset counter
                next_state = s1_red;  // Transition to red state
            end

            s1_red: begin
                red = 1;
                if (cnt == 0) begin
                    next_state = s3_green;  // Transition to green
                end
            end

            s2_yellow: begin
                yellow = 1;
                if (cnt == 0) begin
                    next_state = s1_red;  // Transition to red
                end
            end

            s3_green: begin
                green = 1;
                if (cnt == 0) begin
                    next_state = s2_yellow;  // Transition to yellow
                end
            end

            default: begin
                next_state = idle;  // Default to idle state
            end
        endcase
    end

    // Counter and timing logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd60;  // Reset to default green time
        end else begin
            if (pass_request && green) begin
                // If pedestrian request and green light, limit green to 10
                cnt <= (cnt > 10) ? 10 : cnt;
            end else if (green && !p_green) begin
                // Transition to green; initialize counter
                cnt <= 8'd60;
            end else if (yellow && !p_yellow) begin
                // Transition to yellow; initialize counter
                cnt <= 8'd5;
            end else if (red && !p_red) begin
                // Transition to red; initialize counter
                cnt <= 8'd10;
            end else if (cnt > 0) begin
                // Default behavior: decrement counter
                cnt <= cnt - 1;
            end
        end
    end

    // Output light state storage
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