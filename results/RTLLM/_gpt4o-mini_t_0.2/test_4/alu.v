module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    reg [32:0] temp_result; // for carry and overflow calculations
    reg temp_zero;
    
    always @(*) begin
        case (aluc)
            ADD:   temp_result = {1'b0, a} + {1'b0, b}; // 33-bit for carry
            ADDU:  temp_result = {1'b0, a} + {1'b0, b}; // Unsigned addition
            SUB:   temp_result = {1'b0, a} - {1'b0, b}; // 33-bit for carry
            SUBU:  temp_result = {1'b0, a} - {1'b0, b}; // Unsigned subtraction
            AND:   r = a & b;
            OR:    r = a | b;
            XOR:   r = a ^ b;
            NOR:   r = ~(a | b);
            SLT:   r = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            SLTU:  r = (a < b) ? 32'b1 : 32'b0;
            SLL:   r = b << a[4:0];
            SRL:   r = b >> a[4:0];
            SRA:   r = $signed(b) >>> a[4:0];
            SLLV:  r = b << a[4:0];
            SRLV:  r = b >> a[4:0];
            SRAV:  r = $signed(b) >>> a[4:0];
            LUI:   r = {b[15:0], 16'b0};
            default: r = 32'bz; // undefined operation
        endcase
        
        // After calculation, update the zero, carry, negative, overflow, and flag signals
        temp_zero = (r == 32'b0);
        zero = temp_zero;
        negative = r[31]; // check MSB for negativity
        
        // Check for carry and overflow in arithmetic operations
        carry = (aluc == ADD || aluc == SUB) ? temp_result[32] : 1'b0;
        overflow = (aluc == ADD || aluc == SUB) ? (temp_result[32] ^ temp_result[31]) : 1'b0;
        
        // Set flag for SLT and SLTU operations
        flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0; // r[0] will be 1 or 0
    end
endmodule