module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,  // Input width for operands
    parameter STG_WIDTH = 16   // Width of each pipeline stage
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

    // Number of pipeline stages
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Internal registers for pipeline stages
    reg [DATA_WIDTH:0] pipeline_result [0:NUM_STAGES-1]; // Holds intermediate sums
    reg [NUM_STAGES:0] pipeline_enable;                 // Synchronizes enable signal
    reg [DATA_WIDTH-1:0] adda_stage [0:NUM_STAGES-1];   // Staged adda input
    reg [DATA_WIDTH-1:0] addb_stage [0:NUM_STAGES-1];   // Staged addb input
    
    integer i;

    // Reset logic for pipeline_registers and pipeline enable
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and enable flags
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                pipeline_result[i] <= 0;
                adda_stage[i] <= 0;
                addb_stage[i] <= 0;
            end
            pipeline_enable <= 0;
            o_en <= 0; // Default output enable
        end 
        else begin
            // On valid clock edge, propagate stages
            pipeline_enable[0] <= i_en; // First stage enable flips on input enable
            o_en <= pipeline_enable[NUM_STAGES]; // Output enable set by last stage

            // Propagate inputs and compute partial sums in stages
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (i == 0) begin
                    // First stage directly uses the input
                    adda_stage[i] <= adda;
                    addb_stage[i] <= addb;
                    pipeline_result[i] <= {1'b0, adda[STG_WIDTH-1:0]} + {1'b0, addb[STG_WIDTH-1:0]};
                end else begin
                    // Subsequent stages use results from the previous stage
                    adda_stage[i] <= adda_stage[i-1] >> STG_WIDTH; // Shift right for next stage
                    addb_stage[i] <= addb_stage[i-1] >> STG_WIDTH;
                    pipeline_result[i] <= pipeline_result[i-1] + 
                                          {1'b0, adda_stage[i][STG_WIDTH-1:0]} + 
                                          {1'b0, addb_stage[i][STG_WIDTH-1:0]};
                end
            end

            // Shift pipeline enable signal for subsequent stages
            for (i = 1; i <= NUM_STAGES; i = i + 1) 
                pipeline_enable[i] <= pipeline_enable[i-1];
        end
    end // always

    // Assign final sum result output from the last pipeline stage
    assign result = pipeline_result[NUM_STAGES-1];

endmodule