module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg [1:0] state,  // Add a register to keep track of the current state
    output reg data_out       // Output signal indicating the presence of pulses
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 'd2;         // Reset the state register to the initial state (wait for rising edge)
        data_out <= 1'b0;
    end else begin
        case (state)
            'd2: begin
                if (data_in == 1'b1 && data_in_old != 1'b1) begin
                    state <= 'd3; // Transition to next state when data_in rises from 0 to 1
                end
                data_out <= 1'b0;
            end

            'd3: begin
                if (data_in == 1'b0 && data_in_old != 1'b0) begin
                    state <= 'd4; // Transition to next state when data_in falls from 1 to 0
                end
                data_out <= 1'b0;
            end

            'd4: begin
                if (data_in == 1'b1 && data_in_old != 1'b1) begin
                    state <= 'd2; // Transition back to initial state when data_in rises from 0 to 1
                end
                data_out <= 1'b1;
            end

            default: begin
                state <= 'd2;         // If an invalid state is encountered, reset the state register
                data_out <= 1'b0;
            end
        endcase
    end
end

assign data_in_old = data_in;  // Assign data_in to a temporary register for DFF usage

endmodule