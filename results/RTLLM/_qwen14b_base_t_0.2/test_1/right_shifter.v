module right_shifter(clk, d, q);  

    input clk;  
    input d;  
    output reg [7:0] q;  

    // Initialize the q register to 0
    initial q = 8'b0;

    // On the rising edge of the clock, shift the contents of q to the right by one bit
    // and insert the new input bit d into the most significant position of the register
    always @(posedge clk) begin
        q[7] <= d;  // Insert the new input bit into the most significant position
        q[6:0] <= q[7:1];  // Shift the remaining bits to the right by one position
    end

endmodule