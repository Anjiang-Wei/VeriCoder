module right_shifter(clk, q, d);  

    input clk;  
    input d;  
    output reg [7:0] q;  
    
    // Initialize the register q to 0
    initial begin
        q = 8'b0;  
    end

    // Always block to handle the right shift operation
    always @(posedge clk) begin
        // Right shift the q register by 1 and insert d into the most significant bit
        q <= {d, q[7:1]};  
    end

endmodule