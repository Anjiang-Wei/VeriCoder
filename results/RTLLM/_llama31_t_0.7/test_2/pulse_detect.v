module pulse_detect(
    input clk,     // Clock signal.
    input rst_n,   // Reset signal (active low).
    input data_in, // One-bit input signal.
    output reg [1:0] data_out  // Output signal indicating the presence of pulses.
);

// Register to keep track of the current state of the pulse detection process
reg [2:0] state;

initial begin
    // Initialize the register with the reset value (000)
    state = 3'b000;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set state to initial state and data_out to 0
        state <= 3'b000;
        data_out <= 2'b00;
    end else begin
        case (state)
            3'b000: begin // Initial state: Waiting for the first rising edge of data_in
                if (data_in) begin
                    state <= 3'b001; // Transition to next state
                end
            end

            3'b001: begin // State 1: Waiting for a falling edge of data_in after a rising edge
                if (~data_in && data_in_next) begin
                    state <= 3'b010; // Transition to next state
                end else if (data_in) begin
                    state <= 3'b011; // Transition to next state
                end
            end

            3'b010: begin // State 2: Waiting for a rising edge of data_in after a falling edge
                if (data_in && ~data_in_next) begin
                    state <= 3'b100; // Transition to next state
                end else if (~data_in) begin
                    state <= 3'b101; // Transition to next state
                end
            end

            3'b011: begin // State 3: Waiting for a falling edge of data_in after two rising edges in succession
                if (~data_in && data_in_next) begin
                    state <= 3'b100; // Transition to next state
                end else if (data_in) begin
                    state <= 3'b101; // Transition to next state
                end
            end

            3'b100: begin // State 4: Waiting for a rising edge of data_in after three falling edges in succession
                if (data_in && ~data_in_next) begin
                    state <= 3'b110; // Transition to next state
                    data_out <= 2'b01; // Set data_out to indicate the end of a pulse
                end else if (~data_in) begin
                    state <= 3'b101; // Transition to next state
                end
            end

            3'b101: begin // State 5: Waiting for a falling edge of data_in after three rising edges in succession
                if (~data_in && data_in_next) begin
                    state <= 3'b110; // Transition to next state
                    data_out <= 2'b01; // Set data_out to indicate the end of a pulse
                end else if (data_in) begin
                    state <= 3'b011; // Transition to next state
                end
            end

            3'b110: begin // State 6: No more transitions
                state <= 3'b000;
                data_out <= 2'b00; // Reset data_out for the next pulse detection process
            end
        endcase
    end
end

// Register to hold the value of data_in on the previous clock cycle
reg prev_data_in;

always @(posedge clk) begin
    prev_data_in <= data_in;
end

assign data_out = (state == 3'b110) ? 2'b01 : 2'b00;

endmodule // pulse_detect