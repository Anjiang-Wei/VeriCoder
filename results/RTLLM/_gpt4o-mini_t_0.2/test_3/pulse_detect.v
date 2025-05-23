module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State declaration for pulse detection
typedef enum reg [1:0] {
    IDLE = 2'b00,    // Waiting for pulse to start
    HIGH1 = 2'b01,  // First cycle of pulse (data_in = 1)
    LOW1 = 2'b10     // Next cycle (data_in returns to 0)
} state_t;

state_t current_state, next_state;

// Combinational logic for next state generation
always @* begin
    next_state = current_state; // Default to hold state
    data_out = 0;               // Default output to 0

    case (current_state)
        IDLE: begin
            if (data_in) begin
                next_state = HIGH1; // Transition to HIGH state
            end
        end
        
        HIGH1: begin
            if (!data_in) begin
                next_state = LOW1; // Transition to LOW state
            end
            // Still in HIGH state, data_out remains 0
        end
        
        LOW1: begin
            if (!data_in) begin
                data_out = 1; // End of pulse, set data_out to 1
                next_state = IDLE; // Transition back to IDLE
            end else begin
                next_state = HIGH1; // If data_in is still high, stay in HIGH1
            end
        end
        
        default: begin
            next_state = IDLE; // Reset to IDLE for safety
        end
    endcase
end

// Sequential logic to update state on clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE; // Initialize state to IDLE on reset
        data_out <= 0;         // Ensure data_out is 0
    end else begin
        current_state <= next_state; // Update state
    end
end

endmodule