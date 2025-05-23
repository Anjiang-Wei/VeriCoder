module right_shifter(
    input  clk,
    input  d,
    output  reg [7:0] q
);

initial begin
    q <= 8'b00000000; // Initialize q to all zeros
end

always @(posedge clk) begin
    // Shift the contents of the q register to the right by one bit
    q[6:0] <= q[7:1];
    
    // Insert the new input bit d into the most significant position of the register
    q[7] <= d;
end

endmodule