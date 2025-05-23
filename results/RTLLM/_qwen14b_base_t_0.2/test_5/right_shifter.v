module right_shifter(clk, d, q);  

    input  clk;  
    input  d;  
    output reg [7:0] q;  

    always @(posedge clk) begin
        // Right shift q by 1 bit
        q <= {d, q[7:1]};
    end

endmodule