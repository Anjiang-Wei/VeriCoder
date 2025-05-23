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

    // State encoding
    parameter idle = 2'd0,
              s1_red = 2'd1,
              s2_yellow = 2'd2,
              s3_green = 2'd3;

    // Internal registers
    reg [7:0] cnt;  // Counter for timing
    reg [1:0] state; // Current state of the traffic light controller
    reg p_red, p_yellow, p_green; // Previous state outputs

    // State Transition Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case (state)
                idle: begin
                    state <= s1_red; // Transition to red state on reset
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green; // Transition to green when red time is up
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red; // Transition to red when yellow time is up
                    end
                end
                s3_green: begin
                    if (cnt == 0) begin
                        state <= s2_yellow; // Transition to yellow when green time is up
                    end
                end
            endcase
        end
    end

    // Counter Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10; // initialize with 10
        end else begin
            case (state)
                s1_red: begin
                    if (cnt == 0) begin
                        cnt <= 60; // Reset counter on transition from red
                    end else begin
                        // Decrement the counter
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        cnt <= 5; // Reset counter on transition from yellow
                    end else begin
                        // Decrement the counter
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    if (pass_request && cnt > 10) begin
                        cnt <= 10; // Shorten green time if pedestrian button pressed
                    end else if (cnt == 0) begin
                        cnt <= 60; // Reset counter on transition from green
                    end else begin
                        // Decrement the counter
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    cnt <= cnt - 1; // Normal count down
                end
            endcase
        end
    end

    // Assign clock output to the counter value
    assign clock = cnt;

    // Output Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            // Update previous signal states
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;

            // Update the current state outputs
            case (state)
                s1_red: begin
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
                s2_yellow: begin
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end
                s3_green: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end
                default: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end
            endcase
        end
    end
endmodule