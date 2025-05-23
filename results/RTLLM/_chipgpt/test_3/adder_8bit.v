module adder_8bit ( 
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout 
    );

wire [7:1] add; //[sum+1:0] = [a[7:1]+b[7:1]] + cin
assign sum[7:0] = a[7:0] + {add[6:1],cin};
assign cout = add[8];
endmodule