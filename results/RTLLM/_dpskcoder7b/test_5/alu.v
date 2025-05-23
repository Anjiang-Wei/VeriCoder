wire [31:0] res;
    wire [31:0] sum;
    wire [31:0] diff;
    wire [31:0] shift_res;
    wire [31:0] slt_res;
    wire [31:0] sltu_res;
    wire carry_out;
    wire overflow_out;
    
    // Addition
    assign sum = a + b;
    assign carry = carry_out;
    
    // Subtraction
    assign diff = a - b;
    
    // AND operation
    assign res = a & b;
    
    // OR operation
    assign res = a | b;
    
    // XOR operation
    assign res = a ^ b;
    
    // NOR operation
    assign res = ~(a | b);
    
    // Shift operations
    assign shift_res = aluc[0] ? {1'b0, a[31:1]} : a;
    
    // LUI operation
    assign res = {b, 16'b0};
    
    // SLT and SLTU operations
    assign slt_res = a < b ? 32'b1 : 32'b0;
    assign sltu_res = $unsigned(a) < $unsigned(b) ? 32'b1 : 32'b0;
    
    // Overflow and negative flags
    assign negative = a[31] & ~aluc[5] & b[31] & ~sum[31];
    assign overflow_out = (~a[31] & b[31] & sum[31]) | (a[31] & ~b[31] & ~sum[31]);
    
    // Zero output
    assign zero = (res == 32'b0);
    
    // Flag output
    assign flag = (aluc == SLT || aluc == SLTU) ? 1'b1 : 1'bz;
    
    // Result output
    assign r = aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU || aluc == AND || aluc == OR || aluc == XOR || aluc == NOR || aluc == SLL || aluc == SRL || aluc == SRA || aluc == SLLV || aluc == SRLV || aluc == SRAV || aluc == LUI ? res : 32'bz;
    
endmodule