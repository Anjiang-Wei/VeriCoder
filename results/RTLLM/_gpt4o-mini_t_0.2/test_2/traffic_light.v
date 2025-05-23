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

    parameter 	idle = 2'd0,
                s1_red = 2'd1,
                s2_yellow = 2'd2,
                s3_green = 2'd3;

    reg [7:0] cnt;              // Internal counter
    reg [1:0] state;           // Current state
    reg [1:0] next_state;      // Next state
    reg p_red, p_yellow, p_green; // Previous state values

    assign clock = cnt;        // Assign internal counter to output

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;      // Reset state to idle
        end else begin
            state <= next_state; // Transition to next state
        end
    end

    // State machine to determine next state
    always @(*) begin
        case(state)
            idle: begin
                next_state = s1_red; // Transition to red state
            end
            s1_red: begin
                if (cnt == 0) begin
                    next_state = s3_green; // Move to green state after red
                end else begin
                    next_state = s1_red; // Remain in red state
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    next_state = s1_red; // Move to red state after yellow
                end else begin
                    next_state = s2_yellow; // Remain in yellow state
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    next_state = s2_yellow; // Move to yellow state after green
                end else begin
                    next_state = s3_green; // Remain in green state
                end
            end
            default: begin
                next_state = idle; // Fallback to idle state
            end
        endcase
    end

    // Internal counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10; // Reset counter value
        end else begin
            case (state)
                s1_red: begin
                    if (cnt == 0) begin
                        cnt <= 60; // New cycle for green
                    end else begin
                        cnt <= cnt - 1; // Count down
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        cnt <= 5; // New cycle for yellow
                    end else begin
                        cnt <= cnt - 1; // Count down
                    end
                end
                s3_green: begin
                    if (pass_request) begin
                        if (cnt > 10) 
                            cnt <= 10; // Shorten green time if over 10
                    end
                    cnt <= cnt - 1; // Count down
                end
                default: begin
                    cnt <= 10; // Idle state or fallback state
                end
            endcase
        end
    end

    // Output signal management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {red, yellow, green} <= 3'b000; // Reset all lights
            p_red <= 0; 
            p_yellow <= 0; 
            p_green <= 0; 
        end else begin
            // Update previous status
            p_red <= red;
            p_yellow <= yellow;
            p_green <= green;

            // Set light outputs based on the current state
            case(state)
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