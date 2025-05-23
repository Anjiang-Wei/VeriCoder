module right_shifter(clk, q, d);  

    input  clk;  
    input d;  
    output  [7:0] q;  

    reg [7:0] q;

    initial begin
        q = 8'b00000000;  // Initialize q to 0
    end

    always @(posedge clk) begin
        q <= {d, q[7:1]};  // Shift right and insert new input bit
    end

endmodule