module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );
    
    reg [15:0] a_reg = A;  //store the dividend value
    reg [7:0] b_reg = B;   //store the divisor value
    reg [3:0] i;            //temporary variable to store the bit position of A and B
    
    always @(*) begin
        i = 15-B+1;             //get the number of bits in b that are less than or equal to the last bit of A 
        result[i:0] = a_reg[i:0]; //store the remainder in result with all the bits in the dividend greater than or equal to the last bit of B being 1 (because of the above condition)
        
        odd[15:i+1] = 1;       //store the number of "1"s in the dividend greater than the last bit of B in the remainder  
                               
        a_reg[i:0] = a_reg[i:0] >> 1; //shift one position left, which is equivalent to subtracting by B+1 from the dividend since there are i number of "1"s that we have stored in the last i bits of the result.  
    end
    
endmodule