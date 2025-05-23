module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);
    // Define the states for pulse detection
    typedef enum logic [2:0] {
        IDLE,       // Initial state, waiting for the first rising edge
        RISING_EDGE, // State after detecting the first rising edge
        FALLING_EDGE, // State after detecting the falling edge after the rising edge
        PULSE_DETECTED // State indicating the pulse has been detected
    } state_t;

    // Register to hold the current state
    reg [2:0] current_state;
    reg [2:0] next_state;

    // Register to hold the current value of data_in for comparison
    reg data_in_d1;
    reg data_in_d2;

    // Register to hold the delayed value of data_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 0;
            data_in_d2 <= 0;
        end else begin
            data_in_d2 <= data_in_d1;
            data_in_d1 <= data_in;
        end
    end

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in_d1 == 1 && data_in_d2 == 0) begin
                    next_state = RISING_EDGE;
                end else begin
                    next_state = IDLE;
                end
            end
            RISING_EDGE: begin
                if (data_in_d1 == 0 && data_in_d2 == 1) begin
                    next_state = FALLING_EDGE;
                end else begin
                    next_state = RISING_EDGE;
                end
            end
            FALLING_EDGE: begin
                if (data_in_d1 == 0 && data_in_d2 == 0) begin
                    next_state = PULSE_DETECTED;
                end else begin
                    next_state = FALLING_EDGE;
                end
            end
            PULSE_DETECTED: begin
                if (data_in_d1 == 0 && data_in_d2 == 0) begin
                    next_state = IDLE;
                end else begin
                    next_state = PULSE_DETECTED;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else begin
            case (current_state)
                PULSE_DETECTED: data_out <= 1;
                default: data_out <= 0;
            endcase
        end
    end
endmodule