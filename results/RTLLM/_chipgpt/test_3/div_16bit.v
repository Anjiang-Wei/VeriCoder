module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

// declare two register for the 8-bit division logic
reg[15:0] a_reg;
reg[15:0] b_reg;

always @* begin
    a_reg = A;
    b_reg = B;
end

always @* begin
    // extract the 8-bit from the dividend and use them to compare with the divisor
    reg[7:0] temp = {A[15:8], A[7:0]} - b_reg[7:0];
    
    if(temp[7:0]>={B}) //use 1 for 1's complement of the eight-bit dividend
        result[15:0]= {A[15:8], A[7:0]} - b_reg[7:0];   //subtract by 8 to get the quotient and remainder
    else
        result[15:0] = temp;                          //store as is for the remainder
    
    //use 1 for 1's complement of the eight-bit dividend to keep the least significant bit of the dividend for the next step
    odd[15:0]={A[15:8], A[7:0]} - b_reg[7:0];

end

endmodule