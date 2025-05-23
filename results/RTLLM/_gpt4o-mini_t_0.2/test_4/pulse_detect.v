module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    localparam IDLE       = 2'b00;   // Initial state or between pulses
    localparam HIGH_1    = 2'b01;   // First cycle of the pulse detected (data_in = 1)
    localparam HIGH_2    = 2'b10;   // Second cycle of the pulse detected
    localparam LOW       = 2'b11;   // After pulse detected, waiting for low

    // Current state and next state registers
    reg [1:0] state, next_state;

    // Sequential logic to update the state on clk and reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;  // Reset state
            data_out <= 0;  // Reset output
        end else begin
            state <= next_state; // Update state
        end
    end

    // Combinatorial logic to determine the next state and data_out
    always @(*) begin
        // Default assignments
        next_state = state; // Assume no change
        data_out = 0;       // Default data_out to 0
        
        case (state)
            IDLE: begin
                // Looking for the start of a pulse
                if (data_in) begin
                    next_state = HIGH_1; // Move to first high state
                end
            end
            HIGH_1: begin
                // First cycle of pulse detected
                if (data_in) begin
                    next_state = HIGH_2; // Move to second high state
                end else begin
                    next_state = IDLE;   // No pulse detected, go back to IDLE
                end
            end
            HIGH_2: begin
                // Second cycle of pulse detected
                if (!data_in) begin
                    next_state = LOW;    // Pulse ended, move to low state
                    data_out = 1;        // Set output to indicate pulse
                end else begin
                    next_state = HIGH_2; // Continue in HIGH_2 if data_in is still high
                end
            end
            LOW: begin
                // Pulse has ended, waiting to go idle again
                if (data_in) begin
                    next_state = HIGH_1; // New pulse detected
                end else begin
                    next_state = LOW;    // Remain in LOW until data_in goes high again
                end
            end
            default: begin
                next_state = IDLE; // Default case to handle unexpected states
            end
        endcase
    end

endmodule