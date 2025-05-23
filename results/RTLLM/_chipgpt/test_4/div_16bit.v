module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

    reg [15:0] a_reg;
    reg [15:0] b_reg;
    reg [14:0] q;
    reg [15:0] temp_odd;
    
    always @(*) begin
        if (B > A) begin //start with the last bit of dividend to be processed first.
            a_reg = {A, 1'b0}; //copy the last bit of dividend to the next lower bit-position in register 'a_reg'.
            b_reg = B;    //copy the value of divisor to 'b_reg'.
            q = 16'h0000; //initiate zero quotient.
        end
        
        else begin
             a_reg <= {A[15:8], A[7]}; //shift-left 8 bits and copy the remaining bit of dividend to the next lower bit position.
             b_reg <= B - 1;    //subtract one from divisor to keep it in the range [0,255].
             q = q + 1;         //update the quotient with the last bit of dividend.
        end
    end
    
    assign result[15:8] = a_reg[15:8];
    assign result[7:0]   = b_reg[7:0] - q;  //remainder.
    assign odd         = temp_odd;
    
    always @(*) begin
        case (B[7:6]) //use the last 2 bits of divisor as a mask to extract the highest bit-position of dividend.
           2'b01 : temp_odd = 1'b0;
           2'b10 : temp_odd = A[15]; //use the last bit of dividend to get the remainder.
           2'b11 : temp_odd = {A[15:8], A[7] - B[7:6]} + 1; //update the odd with the 16-bit value of divisor that is being used next time around.
        endcase
    end
    
endmodule