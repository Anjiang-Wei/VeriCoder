// Declare internal wires
wire [31:0] ab;
wire [31:0] ac;
wire [31:0] cc;

// Compute the product of a and b
assign ab = a * b;

// Compute the sum of ac and ab
assign cc = c + ab;

// Update the accumulator register
always @(posedge clk, posedge rst) begin
    if (rst) begin
        c <= 0;
    end
    else begin
        c <= cc;
    end
end

endmodule