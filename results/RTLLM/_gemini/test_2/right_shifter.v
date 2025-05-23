module right_shifter(clk, q,d);  

    input  clk;  
    input d;  
    output  [7:0] q;  

    reg [7:0] q;

    initial begin
        q <= 0;
    end

    always @(posedge clk) begin
        q <= (q >> 1);
        q[7] <= d;
    end

endmodule