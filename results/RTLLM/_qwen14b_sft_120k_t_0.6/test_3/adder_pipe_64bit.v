module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output reg o_en
);
    // Pipeline registers for input enable
    reg [1:0] en_reg;
    reg [2:0] en_reg2;

    // Pipeline registers for sum values
    reg [DATA_WIDTH:0] sum_reg [0:STG_WIDTH-1];

    // Pipeline registers for carry signals
    reg [STG_WIDTH-1:0] carry_reg;

    // Initial values for registers
    integer i;
    initial begin
        for (i = 0; i < STG_WIDTH; i = i + 1) begin
            sum_reg[i] = 0;
        end
        carry_reg = 0;
        en_reg = 0;
        en_reg2 = 0;
        o_en = 0;
    end

    // Pipeline stage 1: Enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_reg <= 0;
        end else begin
            en_reg <= {en_reg[1], i_en};
        end
    end

    // Pipeline stage 2: Enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_reg2 <= 0;
        end else begin
            en_reg2 <= {en_reg2[2], en_reg2[1], en_reg[0]};
        end
    end

    // Pipeline stage 3: Calculate sum and carry
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_reg <= 0;
        end else begin
            carry_reg <= {carry_reg[STG_WIDTH-2:0], sum_reg[STG_WIDTH-1][0]};
        end
    end

    // Pipeline stage 4: Calculate sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                sum_reg[i] <= 0;
            end
        end else begin
            sum_reg[0] <= adda + addb + carry_reg[0];
            for (i = 1; i < STG_WIDTH; i = i + 1) begin
                sum_reg[i] <= sum_reg[i-1][DATA_WIDTH:1] + carry_reg[i];
            end
        end
    end

    // Output enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 0;
        end else begin
            o_en <= en_reg2[0];
        end
    end

    // Assign the final sum to the result output
    assign result = sum_reg[STG_WIDTH-1];

endmodule