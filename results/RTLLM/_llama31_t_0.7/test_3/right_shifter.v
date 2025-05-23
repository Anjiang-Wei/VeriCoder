module right_shifter(
    input  clk,
    input d,
    output reg [7:0] q
);

    initial begin
        q = 8'b00000000; // Initialize q to 0
    end

    always @(posedge clk) begin
        q <= {q[6:0], d}; // Shift q right by 1 bit and insert d in MSB
    end

endmodule