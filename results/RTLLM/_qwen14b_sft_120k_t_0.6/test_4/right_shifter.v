module right_shifter(clk, q, d);  

    input  clk;  
    input d;  
    output  [7:0] q;  

    reg [7:0] q;  

    initial begin
        q = 8'b0;  // Initialize q to 0
    end

    always @(posedge clk) begin
        q[7] <= d;  // Insert input d into the most significant bit
        q[6:0] <= q[7:1];  // Right shift the least significant 7 bits
    end

endmodule