module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output reg [15:0] mul_out
);

    reg mul_en_out_reg;
    reg [7:0] mul_a_reg, mul_b_reg;
    wire [7:0] temp [7:0];
    reg [15:0] sum [0:6];
    reg [15:0] mul_out_reg;

    // Input Control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out_reg <= 1'b0;
        else
            mul_en_out_reg <= mul_en_in;
    end

    assign mul_en_out = mul_en_out_reg;

    // Input Registers
    always @(posedge clk) begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial Product Generation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : partial_product
            assign temp[i] = mul_b_reg[i] ? {8'b0, mul_a_reg} : 8'b0;
        end
    endgenerate

    // Partial Sum Calculation
    always @(posedge clk) begin
        sum[0] <= temp[0] + temp[1] + temp[2] + temp[3];
        sum[1] <= temp[4] + temp[5] + temp[6] + temp[7];
        sum[2] <= sum[0] + sum[1];
        sum[3] <= temp[0] + temp[2] + temp[4] + temp[6];
        sum[4] <= temp[1] + temp[3] + temp[5] + temp[7];
        sum[5] <= sum[3] + sum[4];
        sum[6] <= sum[2] + sum[5];
    end

    // Final Product Calculation
    always @(posedge clk) begin
        mul_out_reg <= sum[6];
    end

    // Output Assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 16'b0;
        else
            mul_out <= mul_en_out ? mul_out_reg : 16'b0;
    end

endmodule