module JC_counter(
    input             clk,
    input             rst_n,
    output reg [63:0] Q
);

    // On reset, clear the register
    // Otherwise, shift right by one bit every clock.
    // Feed the inverted LSB back into the MSB.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'd0;
        end else begin
            Q <= { ~Q[0], Q[63:1] };
        end
    end

endmodule