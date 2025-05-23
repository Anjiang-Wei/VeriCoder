module right_shifter(clk, q, d);  

    input clk;  
    input d;  
    output [7:0] q;  

    reg [7:0] q;

    initial begin
        q = 8'b0;
    end

    always @(posedge clk) begin
        q[7] <= d;  // Insert new input bit d into the most significant position
        q[6:0] <= q[7:1];  // Right shift the remaining bits
    end

endmodule