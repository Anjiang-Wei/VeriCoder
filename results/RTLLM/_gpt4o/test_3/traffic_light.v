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

    // State encoding
    parameter  idle = 2'd0,
                s1_red = 2'd1,
                s2_yellow = 2'd2,
                s3_green = 2'd3;

    reg [1:0] state;           // Current state of the traffic light
    reg [1:0] next_state;      // Next state
    reg [7:0] cnt;             // Counter to track timing
    reg p_red, p_yellow, p_green; // Previous signal values for red, yellow, and green
    
    // Internal counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) // Reset counter
            cnt <= 8'd10;
        else begin
            if (pass_request && green && (cnt > 10)) // If pedestrian button pressed during green
                cnt <= 8'd10;
            else if (!green && p_green) // Green period ended
                cnt <= 8'd60;
            else if (!yellow && p_yellow) // Yellow period ended
                cnt <= 8'd5;
            else if (!red && p_red) // Red period ended
                cnt <= 8'd10;
            else if (cnt > 0) // Normal decrement
                cnt <= cnt - 1;
        end
    end

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= idle;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            idle: begin
                if (rst_n)
                    next_state = s1_red;
                else
                    next_state = idle;
            end
            
            s1_red: begin // Red state
                if (cnt == 0)
                    next_state = s3_green; 
                else
                    next_state = s1_red;
            end

            s2_yellow: begin // Yellow state
                if (cnt == 0)
                    next_state = s1_red;
                else
                    next_state = s2_yellow;
            end

            s3_green: begin // Green state
                if (cnt == 0)
                    next_state = s2_yellow;
                else
                    next_state = s3_green;
            end

            default: next_state = idle;
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                idle: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 0;
                end

                s1_red: begin // Red light on
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end

                s2_yellow: begin // Yellow light on
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end

                s3_green: begin // Green light on
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

    // Store previous signal states
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

    // Assign internal counter to output clock
    assign clock = cnt;

endmodule