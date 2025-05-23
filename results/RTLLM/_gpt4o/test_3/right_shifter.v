module right_shifter(clk, d, q);

    input clk;  
    input d;  
    output reg [7:0] q;  // Output q is a register because it holds the value between clock cycles

    // Initialize q to 0 at declaration or using the "initial" block
    initial begin
        q = 8'b00000000; // Initial value of q is 0
    end

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Right shift q and insert d into the most significant bit
    end

endmodule