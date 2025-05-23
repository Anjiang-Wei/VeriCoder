module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout
    );

wire [19:0] result;
//MULTIPLE BIT-LEVEL ADDERS (FULL ADDERS)
full_adder m0 (a[7], b[7], cin, result[0], sum[7]);
full_adder m1 (result[18:9], a[6:0], cout, result[19:18], sum[6]);
full_adder m2 (result[31:24], result[19:18], b[5:0], cout, sum[5]);
assign {sum[7:0], cout} = {sum[7:0], cout};

endmodule