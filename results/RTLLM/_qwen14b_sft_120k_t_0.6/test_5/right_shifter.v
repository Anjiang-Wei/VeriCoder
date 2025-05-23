module right_shifter(clk, d, q);

    input clk;
    input d;
    output reg [7:0] q;

    initial begin
        q = 8'b0;  // Initialize q to 0
    end

    always @(posedge clk) begin
        q <= {d, q[7:1]};  // Shift right by 1 bit and insert d into MSB
    end

endmodule