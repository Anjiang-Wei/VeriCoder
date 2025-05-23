module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk, // Clock input
    input rst_n, // Active low reset signal
    input i_en, // Enable signal for addition operation
    input [DATA_WIDTH-1:0] adda, // 64-bit input operand A
    input [DATA_WIDTH-1:0] addb, // 64-bit input operand B
    output [DATA_WIDTH:0] result, // 65-bit output representing the sum of adda and addb.
    output reg o_en // Output enable signal
);

// Pipeline registers
reg [DATA_WIDTH:0] stage_reg [STG_WIDTH-1:0];
reg [DATA_WIDTH:0] next_stage_reg [STG_WIDTH-1:0];

always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < STG_WIDTH; i++) begin
            stage_reg[i] <= 0;
            next_stage_reg[i] <= 0;
        end
        o_en <= 1'b0;
    end else begin
        // Synchronize input enable signal
        if (!i_en) begin
            for (int i = 0; i < STG_WIDTH-1; i++) begin
                stage_reg[i] <= next_stage_reg[i];
                next_stage_reg[i] <= 0;
            end
            stage_reg[STG_WIDTH-1] <= 0;
        end else begin
            // Calculate sum values for each pipeline stage
            for (int i = STG_WIDTH-2; i >= 0; i--) begin
                next_stage_reg[i+1] <= {stage_reg[i+1][DATA_WIDTH], 
                                        carry_out(stage_reg[i+1][DATA_WIDTH-1:0], stage_reg[i][DATA_WIDTH-1:0])};
            end
            
            // Calculate sum for the first pipeline stage
            next_stage_reg[0] <= {(stage_reg[0][DATA_WIDTH]&adda), addb, 1'b0};
            
            // Update output enable signal
            if (next_stage_reg[STG_WIDTH-1][DATA_WIDTH] == 1) begin
                o_en <= 1;
            end else begin
                o_en <= 0;
            end
            
            // Update pipeline registers
            for (int i = STG_WIDTH-1; i >= 0; i--) begin
                stage_reg[i] <= next_stage_reg[i];
            end
        end
    end
end

// Ripple carry adder function
function [DATA_WIDTH:0] carry_out;
input [DATA_WIDTH-1:0] a, b;
begin
    for (int i = 0; i < DATA_WIDTH-2; i++) begin
        carry_out[i+1] = (a[i]&b[i]) | (a[i]|b[i]);
    end
    carry_out[DATA_WIDTH-1] = a[DATA_WIDTH-1] | b[DATA_WIDTH-1];
end

// Final sum output
assign result = stage_reg[0];

endmodule