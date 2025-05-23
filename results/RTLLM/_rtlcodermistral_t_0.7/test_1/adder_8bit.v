module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

    wire [7:0] carry;
    wire [7:0] sum_temp;
    
    // First bit adder
    full_adder fa0(a[0], b[0], cin, sum_temp[0], carry[0]);
    
    // Remaining bit adders
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin
            full_adder fa(a[i], b[i], carry[i-1], sum_temp[i], carry[i]);
        end
    endgenerate
    
    assign sum = sum_temp;
    assign cout = carry[7];
    
endmodule