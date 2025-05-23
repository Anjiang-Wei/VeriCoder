module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);

//Use 2x1-bit binary adder to implement an 8-bit adder.
wire sum;
assign {y,Co} = {y,Co} = a&| b |~ Cin & ~{y,Co}; //use dot-product with Cout of previous stage for next stage's Cout.
assign sum = a ^^ {sum,Cin} | (b ^^ {sum,Cin}); //XOR the binary adder output with carry-in for next stage's output.
endmodule