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

    reg [7:0] cnt;            // Internal counter
    reg [1:0] state;         // Current state
    reg p_red, p_yellow, p_green; // Previous state signals

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;          // Reset state
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                idle: begin
                    state <= s1_red;  // transition to red state
                end
                s1_red: begin
                    red <= 1;          // activate red light
                    yellow <= 0;
                    green <= 0;
                    if (cnt == 0) 
                        state <= s3_green; // transition to green state
                end
                s2_yellow: begin
                    red <= 0;
                    yellow <= 1;       // activate yellow light
                    green <= 0;
                    if (cnt == 0) 
                        state <= s1_red; // transition to red state
                end
                s3_green: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 1;        // activate green light
                    if (cnt == 0) 
                        state <= s2_yellow; // transition to yellow state
                end
            endcase
        end
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;                 // Reset counter
        end else begin
            if (state == s3_green && p_green) begin
                if (pass_request && cnt > 10) begin
                    cnt <= 10;           // Shorten the green light duration
                end else if (cnt > 0) begin
                    cnt <= cnt - 1;     // Decrement counter
                end
            end else if (state == s2_yellow && p_yellow) begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;     // Decrement counter for yellow state
                end
            end else if (state == s1_red && p_red) begin
                if (cnt > 0) begin
                    cnt <= cnt - 1;     // Decrement counter for red state
                end
            end else begin
                // Reset the counter based on state transitions
                case (state)
                    idle: cnt <= 10;
                    s1_red: cnt <= 10; // Duration for red light
                    s2_yellow: cnt <= 5; // Duration for yellow light
                    s3_green: cnt <= 60; // Duration for green light
                endcase
            end
        end
    end

    // Assign the internal counter to the output clock
    assign clock = cnt;

    // Store previous values of the signals
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