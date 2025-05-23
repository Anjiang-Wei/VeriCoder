module multi_pipe_8bit#(
    parameter size = 8
)(
    input clk,           // Clock signal
    input rst_n,         // Active-low reset
    input mul_en_in,     // Input enable signal
    input [size-1:0] mul_a,  // Multiplicand
    input [size-1:0] mul_b,  // Multiplier

    output reg mul_en_out,    // Output enable signal
    output reg [size*2-1:0] mul_out  // 16-bit product output
);

    // Pipeline registers for multiplicand, multiplier, and enable
    reg [size-1:0] mul_a_reg[1:0];  // 2 pipeline stages for multiplicand
    reg [size-1:0] mul_b_reg[1:0];  // 2 pipeline stages for multiplier
    reg mul_en_reg[2:0];            // Pipeline for enable signal

    // Partial product registers for pipelining
    reg [size*2-1:0] partial_product[1:0];  // Holds intermediate results

    // Pipeline enable flow
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_reg[0] <= 1'b0;
            mul_en_reg[1] <= 1'b0;
            mul_en_reg[2] <= 1'b0;
        end
        else begin
            mul_en_reg[0] <= mul_en_in;          // First stage enable
            mul_en_reg[1] <= mul_en_reg[0];     // Pass through stages
            mul_en_reg[2] <= mul_en_reg[1];
        end
    end

    // Pipeline input registers for multiplicand and multiplier
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg[0] <= 0;
            mul_a_reg[1] <= 0;
            mul_b_reg[0] <= 0;
            mul_b_reg[1] <= 0;
        end
        else if (mul_en_in) begin
            mul_a_reg[0] <= mul_a;          // Capture inputs on enable
            mul_b_reg[0] <= mul_b;
            mul_a_reg[1] <= mul_a_reg[0];  // Pipeline stages
            mul_b_reg[1] <= mul_b_reg[0];
        end
    end

    // Partial product generation in the first pipeline stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_product[0] <= 0;
        end
        else if (mul_en_reg[0]) begin
            partial_product[0] <= mul_a_reg[0] * mul_b_reg[0];  // Calculate partial product
        end
        else begin
            partial_product[0] <= 0;
        end
    end

    // Partial sum/completion in the second pipeline stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_product[1] <= 0;
        end
        else if (mul_en_reg[1]) begin
            partial_product[1] <= partial_product[0];  // Pass the result to the next stage
        end
        else begin
            partial_product[1] <= 0;
        end
    end

    // Final product generation and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
            mul_en_out <= 0;
        end
        else if (mul_en_reg[2]) begin
            mul_out <= partial_product[1];  // Assign the final product
            mul_en_out <= 1'b1;             // Output enable active
        end
        else begin
            mul_out <= 0;
            mul_en_out <= 0;
        end
    end

endmodule