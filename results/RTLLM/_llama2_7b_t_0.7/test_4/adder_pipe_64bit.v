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

// Registers to enable pipeline stages and synchronize input enable signal
localparam REG_WIDTH = STG_WIDTH;
reg [REGS_WIDTH-1:0] pipeline_stage_regs [];

// Clock and reset signals
always #(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipeline_stage_regs <= {1'b0}; // Reset register values
    end else begin
        // Update pipeline stage regs based on input enable signal and clock edge
        case (i_en)
            1'b0: pipeline_stage_regs[0] <= adda;
            1'b1: pipeline_stage_regs[1] <= addb;
            default: ; // Do nothing
        endcase
    end
end

// Sum values for each pipeline stage
always #(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= {1'b0}; // Reset output value
    end else begin
        case (pipeline_stage_regs[0])
            1'b0: result <= adda + carry;
            1'b1: result <= pipeline_stage_regs[1];
            default: ; // Do nothing
        endcase
    end
end

// Output enable signal
always #(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 0; // Reset output enable value
    end else begin
        case (pipeline_stage_regs[1])
            1'b0: o_en <= 1; // Output available
            1'b1: o_en <= 0; // Output not available
            default: ; // Do nothing
        endcase
    end
end