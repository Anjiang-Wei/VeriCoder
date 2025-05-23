module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
) {
  // Instantiate an 8-bit adder for each bit position
  localparam [7:0] BIT_WIDTH = 8; // Bit width of the small adder
  genvar i;
  generate
    for (i = 0; i < BIT_WIDTH; i++) begin: adder_octet
      // Instantiate an 8-bit adder
      adder_octet adder (
        .a(a[i]),
        .b(b[i]),
        . Cin(Cin),
        .y(y[i]),
        .Co(Co)
      );
    end
  endgenerate
endmodule