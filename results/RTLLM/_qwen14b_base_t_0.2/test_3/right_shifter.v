module right_shifter(clk, d, q);  

    input clk;  
    input d;  
    output reg [7:0] q;  

    always @(posedge clk) begin
        q <= {d, q[7:1]};  // Shift right by 1 bit and insert d into the most significant bit
    end

endmodule