module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );
    
    reg [15:0] a_reg, b_reg;
    
    // Combinational block to store A and B values in registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end
    
    // Combinational block to perform division
    always @(*) begin
        reg [15:0] quotient = 16'b0;
        reg [15:0] remainder = a_reg;
        
        // Perform the division
        for (int i = 0; i < 16; i = i + 1) begin
            if (remainder[15:8] >= b_reg) begin
                remainder[15:8] <= remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end
            else begin
                quotient[i] = 1'b0;
            end
            remainder[15:9] <= {remainder[14:9], 1'b0};
        end
        
        result = quotient;
        odd = remainder[15:0];
    end
endmodule