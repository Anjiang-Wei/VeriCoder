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

    // Pipeline registers
    reg [DATA_WIDTH-1:0] adda_reg;
    reg [DATA_WIDTH-1:0] addb_reg;
    reg [DATA_WIDTH:0] sum_reg;
    reg [DATA_WIDTH-1:0] carry_reg;
    reg [STG_WIDTH-1:0] stage_reg;

    // Pipeline stages
    localparam STG1 = 1'b1,
               STG2 = 1'b1,
               STG3 = 1'b1,
               STG4 = 1'b1,
               STG5 = 1'b1,
               STG6 = 1'b1,
               STG7 = 1'b1,
               STG8 = 1'b1;

    // Pipeline registers update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset registers
            adda_reg <= 0;
            addb_reg <= 0;
            sum_reg <= 0;
            carry_reg <= 0;
            stage_reg <= 0;
            o_en <= 0;
        end else if (i_en) begin
            // Update registers
            adda_reg <= adda;
            addb_reg <= addb;
            carry_reg <= 0;
            stage_reg <= STG1;
            o_en <= 0;
        end else begin
            // Pipeline stages
            case (stage_reg)
                STG1: begin
                    sum_reg <= adda_reg + addb_reg;
                    stage_reg <= STG2;
                end
                STG2: begin
                    sum_reg <= sum_reg + carry_reg;
                    stage_reg <= STG3;
                end
                STG3: begin
                    sum_reg <= sum_reg + carry_reg;
                    stage_reg <= STG4;
                end
                STG4: begin
                    sum_reg <= sum_reg + carry_reg;
                    stage_reg <= STG5;
                end
                STG5: begin
                    sum_reg <= sum_reg + carry_reg;
                    stage_reg <= STG6;
                end
                STG6: begin
                    sum_reg <= sum_reg + carry_reg;
                    stage_reg <= STG7;
                end
                STG7: begin
                    sum_reg <= sum_reg + carry_reg;
                    stage_reg <= STG8;
                end
                STG8: begin
                    sum_reg <= sum_reg + carry_reg;
                    o_en <= 1;
                end
                default: begin
                    // Reset pipeline
                    adda_reg <= 0;
                    addb_reg <= 0;
                    sum_reg <= 0;
                    carry_reg <= 0;
                    stage_reg <= 0;
                    o_en <= 0;
                end
            endcase
        end
    end

    // Output logic
    assign result = sum_reg;

endmodule