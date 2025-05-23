module right_shifter(clk, q, d);

    input clk;
    input d;
    output [7:0] q;

    reg [7:0] q = 0; // Initialize q to 0

    always @(posedge clk) begin
        q <= (q >> 1); // Shift q right by 1 bit
        q[7] <= d; // Insert input d into most significant position of q
    end

endmodule