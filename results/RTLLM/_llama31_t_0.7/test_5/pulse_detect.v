module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define a register to keep track of the current state of the pulse detection process
reg [2:0] state;

initial begin
    // Initialize the state register in the reset condition
    state = 3'h00;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state register and data_out output in the reset condition
        state <= 3'h00;
        data_out <= 1'b0;
    end else begin
        case (state)
            3'h00: begin
                // If data_in is 1, transition to next state
                if (data_in) state <= 3'h01;
                else state <= 3'h00;
            end

            3'h01: begin
                // If data_in remains 1 for two cycles, transition to next state
                if (~data_in | ~data_in[2]) state <= 3'h02;
                else state <= 3'h01;
            end

            3'h02: begin
                // If data_in changes from 1 to 0 in the next cycle, pulse detected
                if (data_in & ~data_in[2]) data_out <= 1'b1;
                else state <= 3'h00;
            end

            default: state <= 3'h00; // Invalid state, reset it to initial state
        endcase
    end
end