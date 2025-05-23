module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);
    
    wire [7:0] s;
    assign s[0] = a[0] ^ b[0] ^ cin;
    assign cout = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    assign sum[0] = s[0];
    
    genvar i;
    generate
        for(i=1; i<=7; i=i+1) begin : fa
            assign s[i] = a[i] ^ b[i] ^ s[i-1];
            assign cout = (a[i] & b[i]) | (a[i] & s[i-1]) | (b[i] & s[i-1]);
            assign sum[i] = s[i];
        end
    endgenerate
endmodule