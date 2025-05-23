module multi_pipe_8bit #(
    parameter SIZE = 8
)(
    input clk,
    input rst_n,
    input mul_en_in,
    input [SIZE-1:0] mul_a,
    input [SIZE-1:0] mul_b,
    output reg mul_en_out,
    output reg [SIZE*2-1:0] mul_out
);

    // Internal registers and wires
    reg mul_en_out_reg;
    reg [SIZE-1:0] mul_a_reg, mul_b_reg;
    wire [SIZE-1:0] mul_b_shifted;
    reg [SIZE*2-1:0] sum [SIZE-1:0];
    reg [SIZE*2-1:0] mul_out_reg;

    // Input control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 1'b0;
        end else if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
        end
    end
    assign mul_en_out = mul_en_out_reg;

    // Input registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= {SIZE{1'b0}};
            mul_b_reg <= {SIZE{1'b0}};
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial product generation
    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : pp_gen
            assign mul_b_shifted[i] = mul_b_reg[i];
            assign sum[i] = mul_a_reg * mul_b_shifted[i];
        end
    endgenerate

    // Partial sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= {SIZE{1'b0}};
        end else if (mul_en_in) begin
            mul_out_reg <= sum[0];
            for (i = 1; i < SIZE; i = i + 1) begin
                mul_out_reg <= mul_out_reg + sum[i];
            end
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {SIZE{1'b0}};
        end else if (mul_en_out_reg) begin
            mul_out <= mul_out_reg;
        end
    end

endmodule