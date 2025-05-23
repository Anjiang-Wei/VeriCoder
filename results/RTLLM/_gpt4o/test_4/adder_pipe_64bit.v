module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16 // Width of each pipeline stage
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

    // Internal signals
    reg [DATA_WIDTH-1:0] reg_adda[0:3];
    reg [DATA_WIDTH-1:0] reg_addb[0:3];
    reg [DATA_WIDTH:0] reg_sum[0:3];
    reg pipe_enable[0:3];

    // Stage 1: Register inputs and enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_adda[0] <= 0;
            reg_addb[0] <= 0;
            pipe_enable[0] <= 0;
        end else if (i_en) begin
            reg_adda[0] <= adda;
            reg_addb[0] <= addb;
            pipe_enable[0] <= i_en;
        end
    end

    // Stage 1 computation (partial addition of lower 16-bits)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_sum[0] <= 0;
        end else if (pipe_enable[0]) begin
            reg_sum[0] <= reg_adda[0][15:0] + reg_addb[0][15:0];
        end
    end

    // Stage 2: Register intermediate results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_adda[1] <= 0;
            reg_addb[1] <= 0;
            pipe_enable[1] <= 0;
        end else if (pipe_enable[0]) begin
            reg_adda[1] <= reg_adda[0];
            reg_addb[1] <= reg_addb[0];
            pipe_enable[1] <= pipe_enable[0];
        end
    end

    // Stage 2 computation (partial addition of mid 16-bits and carry from stage 1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_sum[1] <= 0;
        end else if (pipe_enable[1]) begin
            reg_sum[1] <= {1'b0, reg_adda[1][31:16]} + {1'b0, reg_addb[1][31:16]} + reg_sum[0][16];
        end
    end

    // Stage 3: Register intermediate results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_adda[2] <= 0;
            reg_addb[2] <= 0;
            pipe_enable[2] <= 0;
        end else if (pipe_enable[1]) begin
            reg_adda[2] <= reg_adda[1];
            reg_addb[2] <= reg_addb[1];
            pipe_enable[2] <= pipe_enable[1];
        end
    end

    // Stage 3 computation (partial addition of upper 16-bits and carry from stage 2)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_sum[2] <= 0;
        end else if (pipe_enable[2]) begin
            reg_sum[2] <= {1'b0, reg_adda[2][47:32]} + {1'b0, reg_addb[2][47:32]} + reg_sum[1][16];
        end
    end

    // Stage 4: Register intermediate results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_adda[3] <= 0;
            reg_addb[3] <= 0;
            pipe_enable[3] <= 0;
        end else if (pipe_enable[2]) begin
            reg_adda[3] <= reg_adda[2];
            reg_addb[3] <= reg_addb[2];
            pipe_enable[3] <= pipe_enable[2];
        end
    end

    // Stage 4 computation (final addition of highest 16-bits and carry from stage 3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_sum[3] <= 0;
        end else if (pipe_enable[3]) begin
            reg_sum[3] <= {1'b0, reg_adda[3][63:48]} + {1'b0, reg_addb[3][63:48]} + reg_sum[2][16];
        end
    end

    // Final output computation
    assign result = {reg_sum[3][16:0], reg_sum[2][15:0], reg_sum[1][15:0], reg_sum[0][15:0]};
    
    // Output enable signal generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 0;
        end else begin
            o_en <= pipe_enable[3];
        end
    end

endmodule