module traffic_light
    (
        input wire rst_n, 
        input wire clk, 
        input wire pass_request,
        output wire [7:0] clock,
        output reg red,
        output reg yellow,
        output reg green
    );

    // State parameters for the finite state machine
    parameter idle = 2'd0,
              s1_red = 2'd1,
              s2_yellow = 2'd2,
              s3_green = 2'd3;

    // Internal registers for the counter and state
    reg [7:0] cnt;
    reg [1:0] state;
    reg [1:0] next_state;

    // Previous signals for red, yellow, green
    reg p_red;
    reg p_yellow;
    reg p_green;

    // Assign the internal counter to the output clock
    assign clock = cnt;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle; // Initialize to idle state on reset
        end else begin
            state <= next_state; // Transition to the next state
        end
    end

    // State transition conditions
    always @(*) begin
        case (state)
            idle: begin
                red = 0;
                yellow = 0;
                green = 0;
                next_state = s1_red; // Transition to red state
            end

            s1_red: begin
                red = 1;
                yellow = 0;
                green = 0;
                if (cnt == 0) begin
                    next_state = s3_green; // Wait for red phase to complete
                end else begin
                    next_state = s1_red; // Stay in red state
                end
            end

            s2_yellow: begin
                red = 0;
                yellow = 1;
                green = 0;
                if (cnt == 0) begin
                    next_state = s1_red; // Wait for yellow phase to complete
                end else begin
                    next_state = s2_yellow; // Stay in yellow state
                end
            end

            s3_green: begin
                red = 0;
                yellow = 0;
                green = 1;
                if (cnt == 0) begin
                    next_state = s2_yellow; // Wait for green phase to complete
                end else begin
                    next_state = s3_green; // Stay in green state
                end
            end

            default: begin
                next_state = idle; // Default state is idle
            end
        endcase
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10; // Reset the counter
        end else begin
            case (state)
                idle: begin
                    cnt <= 8'd0; // Reset counter in idle state
                end

                s1_red: begin
                    if (cnt == 0) begin
                        cnt <= 8'd60; // Red duration
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s2_yellow: begin
                    if (cnt == 0) begin
                        cnt <= 8'd5; // Yellow duration
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s3_green: begin
                    if (pass_request && cnt > 8'd10) begin
                        cnt <= 8'd10; // Shorten green time if pass_request signal is active
                    end else if (!p_green && green) begin
                        cnt <= 8'd60; // Set full green time
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                default: begin
                    cnt <= 8'd10; // Default counter value
                end
            endcase
        end
    end

    // Capture the previous values of red, yellow, and green signals
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