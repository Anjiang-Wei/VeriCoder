reg [7:0] q;  

    initial 
        q = 8'b0;  

    always @(posedge clk)  
        q <= {q[6:0], d};  

endmodule