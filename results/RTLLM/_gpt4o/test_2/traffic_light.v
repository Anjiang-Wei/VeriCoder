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

    // Define parameters for states
    parameter idle      = 2'd0,
              s1_red    = 2'd1,
              s2_yellow = 2'd2,
              s3_green  = 2'd3;

    // Internal state registers
    reg [1:0] state, next_state;
    reg [7:0] cnt;        // Internal clock counter
    reg p_red, p_yellow, p_green; // Previous light states for state transitions
    
    assign clock = cnt;   // Assign counter value to output clock

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle; // Reset to idle state
        end else begin
            state <= next_state; // Update to next_state on every clock cycle
        end
    end

    // Next state logic and output logic for the traffic light
    always @(*) begin
        // By default, keep previous state values
        next_state = state;

        case (state)
            idle: begin
                // Set outputs to default (all lights off) in idle state
                red = 1'b0;
                yellow = 1'b0;
                green = 1'b0;

                // Transit to s1_red immediately after reset
                next_state = s1_red;
            end
            
            s1_red: begin
                red = 1'b1;    // Red light on
                yellow = 1'b0;
                green = 1'b0;
                
                // Wait for 10 clock cycles for RED
                if (cnt == 0) begin
                    next_state = s3_green;
                end
            end
            
            s2_yellow: begin
                red = 1'b0;
                yellow = 1'b1; // Yellow light on
                green = 1'b0;
                
                // Wait for 5 clock cycles for YELLOW
                if (cnt == 0) begin
                    next_state = s1_red;
                end
            end
            
            s3_green: begin
                red = 1'b0;
                yellow = 1'b0;
                green = 1'b1;  // Green light on
                
                // Wait for GREEN time, or shorten on pass_request
                if (cnt == 0) begin
                    next_state = s2_yellow;
                end
            end
            
            default: begin
                // Safety: reset to idle state if no valid current state
                next_state = idle;
            end
        endcase
    end

    // Counter logic to control timing of states
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10; // Default counter value after reset
        end else begin
            if (state == s1_red) begin
                // Red light timing
                if (cnt == 0) 
                    cnt <= 8'd60; // Re-initialize based on state timing
                else
                    cnt <= cnt - 1;
            end 
        end
    end
endmodule