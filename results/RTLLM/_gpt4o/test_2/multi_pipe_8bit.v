module multi_pipe_8bit#(
    parameter size = 8
)(
    input clk,                      // Clock signal
    input rst_n,                    // Active-low reset
    input mul_en_in,                // Input enable signal
    input [size-1:0] mul_a,         // Multiplicand
    input [size-1:0] mul_b,         // Multiplier

    output reg mul_en_out,          // Output enable signal
    output reg [size*2-1:0] mul_out // 16-bit product output
);

    // Internal pipeline registers for multiplicand, multiplier, and enable
    reg [size-1:0] mul_a_reg1, mul_a_reg2;  // Pipeline stages for multiplicand
    reg [size-1:0] mul_b_reg1, mul_b_reg2;  // Pipeline stages for multiplier
    reg mul_en_reg1, mul_en_reg2;           // Pipeline stages for enable signal

    // Internal registers/wires for partial products and sums
    reg [size*2-1:0] partial_product1, partial_product2; // For partial sums/products

    // Sequential logic (pipeline registers)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            mul_a_reg1 <= 0;
            mul_b_reg1 <= 0;
            mul_en_reg1 <= 0;
            mul_a_reg2 <= 0;
            mul_b_reg2 <= 0;
            mul_en_reg2 <= 0;
            partial_product1 <= 0;
            partial_product2 <= 0;
            mul_out <= 0;
            mul_en_out <= 0;
        end else begin
            // Stage 1: Latch inputs into pipeline
            if (mul_en_in) begin
                mul_a_reg1 <= mul_a;
                mul_b_reg1 <= mul_b;
                mul_en_reg1 <= mul_en_in;
            end else begin
                mul_a_reg1 <= mul_a_reg1;
                mul_b_reg1 <= mul_b_reg1;
                mul_en_reg1 <= mul_en_reg1;
            end

            // Stage 2: Compute partial products in pipeline
            mul_a_reg2 <= mul_a_reg1;
            mul_b_reg2 <= mul_b_reg1;
            mul_en_reg2 <= mul_en_reg1;
            partial_product1 <= mul_a_reg1 * mul_b_reg1;

            // Stage 3: Final computation and output
            mul_out <= partial_product1;  // The 16-bit product
            mul_en_out <= mul_en_reg2;   // Output enable signal
        end
    end

endmodule