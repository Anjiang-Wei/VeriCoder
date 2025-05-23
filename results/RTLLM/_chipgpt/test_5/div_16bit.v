module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );
    
//use case statement for combinational blocks
always @(*) begin
    a_reg = A;
    b_reg = B;
    d[7:0] = 0;
    r[15:0] = 'b0;
    i = 0; //counter of bits remaining in A that will be compared with the divisor
    
    for (i=0; i<B'length; i=i+1) begin   //use case statement for register file operations 
        if(A[i]>b_reg[i]) begin //compare the "dividend" bit with the "divisor" bit and then set the quotient to 1 or zero accordingly
            r = {1, A[i], r};         //result is an 8-bit vector. Set the "remainder" to 0, as a remainder of a 8-bit division will always be in the last 8 bits  
        else begin                    //the "remainder" is set to 1 if the dividend bit was smaller than the divisor bit (i.e. when A[i] < b_reg[i])
            r = {0,A[i],r};         
        end  
        
        
    d = d << 1;                      //move the "d" register to the left with 8 bits
    
        if(d == 'b111_1111) begin       //if all bits of A were not compared, then start from the first bit (i.e. "r" should now contain {1,A[0]})  
            result = r;                  //store the "quotient" in a vector of 8 bits (result will be 0 if there are no more un-compared bits)  
            odd = 'b0;                    //"odd" is already 15-bit long. So we can just set it to zero, as this indicates that all bits have been compared with the divisor and hence "d" will be equal to 1 (i.e. "r" should now contain {1,A[0]})
            i = i + 1;                   //increase the counter by one as there is an un-compared bit in A
        end
    end
end

endmodule