wire [31:0] sum;
reg [31:0] c;
parameter N=32'd3456789; //32*32=1024(binary)
always @(posedge clk or posedge rst)
    if (rst) c <= 0;
    else c <= c + a * b;

Multiply and Accumulate:
wire [31:0] m; //product of two input vectors
assign m = a*b;
//register to accumulate the product(m) into a 32-bit word.
always @(posedge clk or posedge rst)
    if (rst) c <= 0;
    else c <= c + m; //adds m to c, register of sum.

endmodule