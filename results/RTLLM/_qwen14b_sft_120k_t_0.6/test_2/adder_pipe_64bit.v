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
    reg [STG_WIDTH-1:0] i_en_pipe;
    reg [DATA_WIDTH:0] sum_pipe [STG_WIDTH-1:0];

    // Pipeline stage initialization
    integer i;
    initial begin
        for (i = 0; i < STG_WIDTH; i = i + 1) begin
            i_en_pipe[i] = 1'b0;
            sum_pipe[i] = {1'b0, {DATA_WIDTH{1'b0}}};
        end
    end

    // Pipeline stage generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_en_pipe <= {STG_WIDTH{1'b0}};
            sum_pipe <= {{DATA_WIDTH+1{1'b0}}};
            o_en <= 1'b0;
        end else begin
            // Pipeline stages
            i_en_pipe[0] <= i_en;
            sum_pipe[0] <= {1'b0, adda[DATA_WIDTH-1:0]} + {1'b0, addb[DATA_WIDTH-1:0]};
            for (i = 1; i < STG_WIDTH; i = i + 1) begin
                sum_pipe[i] <= sum_pipe[i-1];
            end

            // Output enable signal
            if (i_en_pipe[STG_WIDTH-1]) begin
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

    // Assign result
    assign result = sum_pipe[STG_WIDTH-1];

endmodule