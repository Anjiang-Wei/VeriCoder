// Add your code here
// Sign extension of B to 16-bits
wire [15:0] B_ext = {8'h00, B};

// Register to hold the dividend
reg [15:0] a_reg;

// Register to hold the divisor
reg [15:0] b_reg;

// Register to hold the quotient
reg [15:0] quotient;

// Register to hold the remainder
reg [15:0] remainder;

// Initialize the registers
initial begin
    a_reg = A;
    b_reg = B_ext;
    quotient = 16'b0;
    remainder = 16'b0;
end

// Perform the division
always @(*) begin
    // Loop over each bit of the dividend
    for (integer i = 0; i < 16; i = i + 1) begin
        // If the current bit of the dividend is 1
        if (a_reg[i] == 1'b1) begin
            // Increment the quotient
            quotient = quotient | (16'b1 << i);
            // Calculate the new remainder
            remainder = a_reg - (b_reg << i);
        end
    end
end

// Assign the outputs
assign result = quotient;
assign odd = remainder;
endmodule