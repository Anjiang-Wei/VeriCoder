module right_shifter(clk, q, d);  
    input clk;  
    input d;  
    output reg [7:0] q;  

    // Initialize the q register to 0
    initial begin
        q = 8'b0;
    end

    // On each rising edge of clk, shift q right by one bit and 
    // insert the new input d at the most significant bit (bit 7).
    always @(posedge clk) begin
        q <= (q >> 1);   // Shift right by 1
        q[7] <= d;       // Insert d into the most significant bit
    end  

endmodule