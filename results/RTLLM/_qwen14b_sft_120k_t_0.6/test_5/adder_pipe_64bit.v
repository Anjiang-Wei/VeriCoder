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
    // Pipeline registers for enable signal
    reg [STG_WIDTH-1:0] i_en_pipe;
    // Pipeline registers for sum calculation
    reg [DATA_WIDTH:0] sum_pipe [STG_WIDTH-1:0];
    reg [DATA_WIDTH:0] carry_pipe [STG_WIDTH-1:0];
    reg [DATA_WIDTH:0] sum_temp [STG_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] carry_in [STG_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] carry_out [STG_WIDTH-1:0];

    // Pipeline initialization
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_en_pipe <= {STG_WIDTH{1'b0}};
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                sum_pipe[i] <= {DATA_WIDTH+1{1'b0}};
                carry_pipe[i] <= {DATA_WIDTH+1{1'b0}};
            end
            o_en <= 1'b0;
        end else begin
            // Shift enable signal through pipeline
            i_en_pipe <= {i_en_pipe[STG_WIDTH-2:0], i_en};
            // Calculate sum and carry for each stage
            carry_in[0] <= 1'b0;
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                sum_temp[i] <= sum_pipe[i] + carry_pipe[i] + {carry_in[i], adda[i*DATA_WIDTH/STG_WIDTH+DATA_WIDTH/STG_WIDTH-1:i*DATA_WIDTH/STG_WIDTH]} + {carry_in[i], addb[i*DATA_WIDTH/STG_WIDTH+DATA_WIDTH/STG_WIDTH-1:i*DATA_WIDTH/STG_WIDTH]};
                carry_out[i] <= sum_temp[i][DATA_WIDTH];
                sum_pipe[i] <= sum_temp[i][DATA_WIDTH-1:0];
                carry_pipe[i] <= {carry_out[i], carry_pipe[i][DATA_WIDTH:1]};
                carry_in[i+1] <= carry_out[i];
            end
            // Update output enable signal
            o_en <= i_en_pipe[STG_WIDTH-1];
        end
    end
    // Assign result to output
    assign result = sum_pipe[STG_WIDTH-1];
endmodule