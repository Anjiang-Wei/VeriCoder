module right_shifter(clk, q, d);  

    input  clk;  
    input d;  
    output reg [7:0] q;  

    // Initialize the register q to 0
    initial begin
        q = 8'b00000000;
    end

    // On each rising edge of the clock, shift q right and insert d at the MSB
    always @(posedge clk) begin
        q <= {d, q[7:1]};  // Shift right and insert d at the MSB
    end

endmodule