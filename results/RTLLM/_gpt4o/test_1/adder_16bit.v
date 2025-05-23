// 8-bit full adder submodule
module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    // Internal carry signals
    wire [7:0] carry;

    // Full adder logic for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bit
            if (i == 0) begin
                // Add LSB with carry-in
                assign {carry[i], y[i]} = a[i] + b[i] + Cin;
            end else begin
                // Add subsequent bits with carry
                assign {carry[i], y[i]} = a[i] + b[i] + carry[i-1];
            end
        end
    endgenerate

    // Final carry-out
    assign Co = carry[7];
endmodule

// 16-bit full adder module
module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,  // Carry-in
    output wire [15:0] y,  // Sum
    output wire Co  // Carry-out
);
    // Intermediate signals for carry and sum
    wire C_mid;  // Carry-out from the lower 8-bit adder
    wire [7:0] y_lower, y_upper;

    // Instantiate the lower 8-bit adder (bits [7:0])
    adder_8bit adder_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y_lower),
        .Co(C_mid)
    );

    // Instantiate the upper 8-bit adder (bits [15:8])
    adder_8bit adder_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C_mid),  // Carry-out of lower adder feeds into carry-in of upper adder
        .y(y_upper),
        .Co(Co)
    );

    // Combine lower and upper results into the final output
    assign y = {y_upper, y_lower};
endmodule