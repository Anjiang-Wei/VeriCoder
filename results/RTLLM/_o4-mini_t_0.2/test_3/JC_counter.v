module JC_counter(
    input             clk,
    input             rst_n,
    output reg [63:0] Q
);

    // On reset, clear the register.
    // Otherwise, shift right and insert the inverse of the LSB at MSB.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;
        end else begin
            // If Q[0] == 0, ~Q[0] = 1 → MSB = 1 (shifting “up”)
            // If Q[0] == 1, ~Q[0] = 0 → MSB = 0 (shifting “down”)
            Q <= { ~Q[0], Q[63:1] };
        end
    end

endmodule