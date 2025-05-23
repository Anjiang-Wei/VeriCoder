module multi_pipe_8bit#(
    parameter size = 8  // Parameter for the size of the inputs
)(
    input               clk,          // Clock signal
    input               rst_n,        // Active-low reset signal
    input [size-1:0]    mul_a,        // Multiplicand input
    input [size-1:0]    mul_b,        // Multiplier input
    input               mul_en_in,    // Input enable signal
    
    output reg          mul_en_out,   // Output enable signal
    output reg [size*2-1:0] mul_out   // 16-bit output product
);

    // Internal registers for pipelining
    reg [size-1:0]    mul_a_reg_1, mul_b_reg_1;       // Stage 1 input registers
    reg [size-1:0]    mul_a_reg_2, mul_b_reg_2;       // Stage 2 input registers
    reg [size*2-1:0]  partial_product_reg;            // Stage 2 accumulated product
    
    reg               mul_en_reg_1, mul_en_reg_2;     // Pipeline enable registers

    // STAGE 1: Register the inputs and input-enabled signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg_1 <= 0;
            mul_b_reg_1 <= 0;
            mul_en_reg_1 <= 0;
        end else if (mul_en_in) begin
            mul_a_reg_1 <= mul_a;
            mul_b_reg_1 <= mul_b;
            mul_en_reg_1 <= mul_en_in;
        end
    end

    // STAGE 2: Compute partial product and propagate enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg_2 <= 0;
            mul_b_reg_2 <= 0;
            partial_product_reg <= 0;
            mul_en_reg_2 <= 0;
        end else if (mul_en_reg_1) begin
            mul_a_reg_2 <= mul_a_reg_1;
            mul_b_reg_2 <= mul_b_reg_1;
            
            // Compute partial product
            partial_product_reg <= mul_a_reg_1 * mul_b_reg_1;
            mul_en_reg_2 <= mul_en_reg_1;
        end
    end

    // STAGE 3: Store the final product and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
            mul_en_out <= 0;
        end else if (mul_en_reg_2) begin
            mul_out <= partial_product_reg;  // Assign the computed product
            mul_en_out <= mul_en_reg_2;     // Propagate output enable
        end else begin
            mul_out <= 0;
            mul_en_out <= 0;
        end
    end

endmodule