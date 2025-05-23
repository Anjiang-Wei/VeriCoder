reg [7:0] q;  
    initial begin  
        q <= 8'b0;  
    end  

    assign q = (q >> 1);  
    always @(posedge clk) begin
        q[7] <= d;
    end

endmodule