module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);

wire [7:0] sum;
adder_8 adder (a[15],b[15],Cin,y[7],Co);
assign {y[6:0],Co} = sum[7:0];

endmodule