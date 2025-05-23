module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam IDLE   = 2'b00; // Initial state, waiting for pulse
localparam HIGH   = 2'b01; // High state when data_in is 1
localparam LOW    = 2'b10; // Low state following a high

reg [1:0] state;    // Current state
reg [1:0] next_state; // Next state for FSM

// Always block for state transitions and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;  // Reset state to IDLE
        data_out <= 0;  // Reset output to 0
    end else begin
        state <= next_state; // Transition to the next state
    end
end

// Always block for determining the next state and output
always @(*) begin
    // Default assignments
    next_state = state;
    data_out = 0; // Default data_out to 0

    case(state)
        IDLE: begin
            if (data_in) begin
                next_state = HIGH; // Detected rising edge, move to HIGH state
            end
        end
        
        HIGH: begin
            if (!data_in) begin
                next_state = LOW; // Detected falling edge, move to LOW state
            end
        end
        
        LOW: begin
            if (data_in) begin
                next_state = HIGH; // Detected rising edge again, move back to HIGH
            end else begin
                data_out = 1; // End of pulse detected, set output to 1
                next_state = IDLE; // Move back to IDLE after pulse
            end
        end
    endcase
end

endmodule