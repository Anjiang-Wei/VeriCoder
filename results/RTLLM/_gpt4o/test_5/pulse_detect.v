module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE    = 2'b00, // Waiting for the start of a pulse
        HIGH    = 2'b01, // Detecting "1" in the pulse
        LOW     = 2'b10  // Waiting for the falling edge of the pulse
    } state_t;

    // Registers to hold state and input synchronization
    state_t current_state, next_state;
    reg data_in_d; // Delayed version of data_in for edge detection

    // Sequential logic: State transition and synchronization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_in_d <= 0; // Reset the delayed input
        end else begin
            current_state <= next_state;
            data_in_d <= data_in; // Synchronize data_in
        end
    end

    // Combinational logic: Next state determination
    always @(*) begin
        next_state = current_state; // Default state remains unchanged
        data_out = 1'b0;            // Default output
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state = HIGH; // Transition to HIGH state when 0 -> 1 edge detected
                end
            end
            HIGH: begin
                if (data_in == 1'b0) begin
                    next_state = LOW; // Transition to LOW state when 1 -> 0 edge detected
                end
            end
            LOW: begin
                if (data_in == 1'b1) begin
                    next_state = HIGH; // Start a new pulse if 0 -> 1 occurs again
                end else begin
                    data_out = 1'b1;  // Indicate a pulse completion
                    next_state = IDLE; // Go back to IDLE state
                end
            end
            default: begin
                next_state = IDLE; // Default to IDLE for safety
            end
        endcase
    end

endmodule