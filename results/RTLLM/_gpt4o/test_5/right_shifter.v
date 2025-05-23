module right_shifter(clk, q, d);

    input  clk;  
    input  d;  
    output reg [7:0] q;  // Declare q as a reg since it will be updated in an always block

    // Initialize q to 0
    initial begin
        q = 8'b0;
    end

    // Process that runs on the rising edge of the clock
    always @(posedge clk) begin
        q <= (q >> 1);  // Perform the right shift
        q[7] <= d;      // Insert the input d into the most significant bit
    end

endmodule