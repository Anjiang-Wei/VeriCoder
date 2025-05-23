reg [7:0] q;  
initial q = 0;  

always @(posedge clk)  
    begin  
        q <= {q[6:0], 1'b0};  
        q[7] <= d;  
    end  
endmodule