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

// Pipelined registers to store intermediate sum values
reg [DATA_WIDTH:0] stage_reg [STG_WIDTH-1:0];

// Register to synchronize i_en with clk and rst_n
reg sync_i_en;

initial begin
    // Initialize output enable signal
    o_en = 0;
end

always @(posedge clk) begin
    if (~rst_n) begin
        // Reset all registers on reset
        stage_reg <= '{DATA_WIDTH{1'b0}};
        sync_i_en <= 1'b0;
        o_en <= 1'b0;
    end else begin
        // Synchronize i_en with clock and reset
        sync_i_en <= i_en;

        // Update pipeline stages
        for (int i = STG_WIDTH-2; i >= 0; i--) begin
            if (sync_i_en) begin
                // Calculate sum value for current stage
                if (i == STG_WIDTH-1) begin
                    // First stage: add input operands and carry
                    stage_reg[i] <= adda + addb;
                end else begin
                    // Subsequent stages: add previous stage's sum and carry
                    let prev_sum = stage_reg[i+1];
                    let prev_carry = (prev_sum[DATA_WIDTH]);
                    stage_reg[i] <= {(prev_sum<<1), prev_carry};
                end

                // Update output enable signal
                if (i == 0) begin
                    o_en <= 1'b1;
                end
            end
        end
    end
end

// Assign result output based on pipeline stages
assign result = stage_reg[STG_WIDTH-1];

endmodule