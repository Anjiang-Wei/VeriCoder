module pe(
    input clk,            // Clock signal
    input rst,            // Reset signal (active high)
    input [31:0] a,       // 32-bit input operand A
    input [31:0] b,       // 32-bit input operand B
    output [31:0] c       // 32-bit accumulated result
);

    reg [31:0] c_reg;     // Register to hold the accumulation result

    // Assign output c to the value of the register
    assign c = c_reg;

    // Sequential logic for multiplication and accumulation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // On reset, set the accumulation register to 0
            c_reg <= 32'b0;
        end else begin
            // Multiply a and b, and accumulate in c_reg
            c_reg <= c_reg + (a * b);
        end
    end
endmodule