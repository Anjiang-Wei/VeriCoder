module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [3:0] state; // Current state of the pulse detection process (4 states)
reg [2:0] count; // Count the number of cycles for each state

initial begin
    state = 0; // Initial state
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        data_out <= 0;
        count <= 0;
    end else begin
        case (state)
            4'd0: // State 0: Waiting for rising edge of data_in
                if (data_in) begin
                    count <= 1; // Transition to next state
                    state <= 'd1; // Increment the state counter
                end else if (~data_out) begin // If no pulse has occurred, output is reset
                    data_out <= 0;
                end

            4'd1: // State 1: Waiting for falling edge of data_in
                if (~data_in) begin
                    count <= 2; // Transition to next state
                    state <= 'd2; // Increment the state counter
                end else if (count == 3 && ~data_out) begin
                    data_out <= 1;
                end

            4'd2: // State 2: Waiting for rising edge of data_in
                if (data_in) begin
                    count <= 0; // Reset the state counter
                    state <= 'd3; // Increment the state counter
                end else if (count == 1 && ~data_out) begin
                    data_out <= 1;
                end

            4'd3: // State 3: Waiting for falling edge of data_in
                if (~data_in) begin
                    count <= 0; // Reset the state counter
                    state <= 'd0; // Transition back to initial state
                end else if (count == 1 && ~data_out) begin
                    data_out <= 1;
                end

            default: // Default case (safety)
                state <= 4'd0;
        endcase
    end
end

endmodule