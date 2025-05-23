module div_16bit(
    input wire [15:0] A, // 16-bit dividend.
    input wire [7:0] B, // 8-bit divisor.

    output wire [15:0] result, // 16-bit quotient.
    output wire [15:0] odd // 16-bit remainder.
);

// Registers to hold the values of A and B.
reg [15:0] a_reg;
reg [7:0] b_reg;

always @(A or B) begin
    // Load new values into registers on any change in input values.
    a_reg <= A;
    b_reg <= B;
end

// Perform division operation.
always @(a_reg or b_reg) begin
    // Get the lower 8 bits of the dividend (matching divisor width).
    reg [7:0] temp = a_reg[7:0];
    
    // Compare and set quotient to 1 if dividend is greater than divisor, otherwise 0.
    if (temp > b_reg)
        result <= {1'b1, 15'h0};
    else
        result <= {1'b0, 15'h0};

    // Calculate remainder as difference between dividend and divisor.
    reg [7:0] rem = temp - b_reg;
    
    // Concatenate the remainder with the highest remaining bit of the dividend.
    odd <= {a_reg[15], rem};
end

// Ensure that result and odd remain updated even when a or b changes.
always @(posedge clk) begin
    if (result == 16'hffff)
        $display("Error: Division by zero in module div_16bit.");
    end

endmodule