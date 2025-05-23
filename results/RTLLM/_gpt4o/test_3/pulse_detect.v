module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);
    
    // Define states to track the pulse sequence
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        DETECT_1 = 2'b01,
        DETECT_0 = 2'b10
    } state_t;

    // State registers
    reg [1:0] current_state, next_state;

    // Sequential logic for state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;  // Reset to IDLE state
        else
            current_state <= next_state;  // Transition to next state
    end

    // Combinational logic for next state and output
    always @(*) begin
        // Default values
        next_state = current_state;
        data_out = 1'b0;
        
        case (current_state)
            IDLE: begin
                // Wait for rising edge (data_in = 1)
                if (data_in)
                    next_state = DETECT_1;
            end

            DETECT_1: begin
                // Wait for falling edge (data_in = 0)
                if (!data_in)
                    next_state = DETECT_0;
            end

            DETECT_0: begin
                // If another rising edge occurs (invalid pulse), go back to IDLE
                if (data_in)
                    next_state = DETECT_1;
                else begin
                    // Valid pulse detected (0 → 1 → 0), output 1
                    data_out = 1'b1;
                    next_state = IDLE;  // Return to IDLE state
                end
            end

            default: begin
                // Default state fallback
                next_state = IDLE;
            end
        endcase
    end

endmodule