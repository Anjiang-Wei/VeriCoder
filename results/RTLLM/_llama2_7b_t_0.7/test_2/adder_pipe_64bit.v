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

// Define pipeline stages and their inputs
localparam PIPELINE_STAGES = 4; // Number of pipeline stages
localparam STAGE_INPUTS[PIPELINE_STages-1] = {
    DATA_WIDTH-1, // Stage 0: input operands A and B
    STG_WIDTH-1, // Stage 1: carry and input operand A
    STG_WIDTH-1, // Stage 2: carry and input operand B
    DATA_WIDTH-1 // Stage 3: output result
};

// Define pipeline registers
localparam PIPELINE_REGISTERS = {
    (${DATA_WIDTH}-1){8{Q}} // Input register for each stage
    (${STG_WIDTH}-1){8{Q}} // Carry and input operand register for each stage
};

// Define clock, reset, and enable signals
input clk;
input rst_n;
input i_en;

// Define output enable signal
output reg o_en;

// Define pipeline stages and their outputs
reg [DATA_WIDTH-1:0] stage_outputs[PIPELINE_STAGES];

always @(*)
begin
    // Initialize pipeline registers to zero
    for (int i = 0; i < PIPELINE_REGISTERS; i++) begin
        stage_outputs[i] <= 0;
    end

    // Handle clock signal
    if (clk) begin
        // Update pipeline stages and their outputs based on enable signal
        for (int i = 0; i < PIPELINE_STAGES; i++) begin
            // Calculate carry and input operand values for next stage
            wire [DATA_WIDTH-1:0] carry = stage_outputs[i+1];
            wire [DATA_WIDTH-1:0] input_a = stage_outputs[i];
            wire [DATA_WIDTH-1:0] input_b = stage_outputs[i+1];

            // Add input operands and carry values for current stage
            stage_outputs[i] <= input_a + input_b + carry;
        end

        // Synchronize output enable signal with clock
        o_en <= i_en & (stage_outputs[PIPELINE_STAGES-1] === result);
    end else begin
        // Hold pipeline stages and their outputs at previous state during reset
        for (int i = 0; i < PIPELINE_REGISTERS; i++) begin
            stage_outputs[i] <= stage_outputs[i];
        end
    end
end

endmodule