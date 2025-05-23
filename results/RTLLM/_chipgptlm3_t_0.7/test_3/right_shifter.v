module right_shifter(clk, q,d);  

    input  clk;  
    input d;  
    output  [7:0] q;  
`initial q = 8'b0;  

    reg [7:0] q;  

    always @(posedge clk) begin  
        q <= {q[6:0], 1'b0};  
        q[7] <= d;  
    end  

endmodule