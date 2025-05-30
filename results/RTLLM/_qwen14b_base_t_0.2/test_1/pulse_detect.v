module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);
    // Define the states for pulse detection
    typedef enum logic [2:0] {
        IDLE,       // Initial state
        RISING_EDGE, // State after detecting a rising edge (0 to 1)
        FALLING_EDGE // State after detecting a falling edge (1 to 0)
    } state_t;

    // Register to hold the current state
    state_t state, next_state;

    // Register to hold the output signal
    reg data_out_reg;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out_reg <= 0;
        end else begin
            state <= next_state;
            data_out <= data_out_reg;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1) begin
                    next_state = RISING_EDGE;
                end else begin
                    next_state = IDLE;
                end
            end
            RISING_EDGE: begin
                if (data_in == 0) begin
                    next_state = FALLING_EDGE;
                end else begin
                    next_state = RISING_EDGE;
                end
            end
            FALLING_EDGE: begin
                if (data_in == 0) begin
                    next_state = IDLE;
                    data_out_reg = 1;
                end else begin
                    next_state = RISING_EDGE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule