module right_shifter(clk, q, d);  

    input clk;  
    input d;  
    output reg [7:0] q;  

    // Initialize q to 0
    initial begin
        q = 8'b00000000;
    end

    // On each rising edge of the clock, perform the right shift
    always @(posedge clk) begin
        q <= {d, q[7:1]};  // Shift right and insert d into MSB
    end

endmodule