module multi_pipe_4bit#(
    parameter size = 4
)(
    input                       clk         ,   
    input                       rst_n       ,
    input   [size-1:0]          mul_a       ,
    input   [size-1:0]          mul_b       ,
    output  reg [size*2-1:0]    mul_out     
);

    parameter N = 2 * size;

    // Declare the intermediate registers for the pipeline stages
    reg [N-1:0] partial_product [0:size-1];  // Holds the partial products
    reg [N-1:0] pipeline_stage_1 [0:size-1]; // Register for Stage 1
    reg [N-1:0] pipeline_stage_2;            // Register for Stage 2 (final summation)

    integer i;

    // Generate Partial Products
    always @(*) begin
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i]) begin
                // Shift partial product by i to align it with the multiplier bit position
                partial_product[i] = mul_a << i;
            end else begin
                // If the multiplier bit is 0, the partial product is 0
                partial_product[i] = 0;
            end
        end
    end

    // Pipeline Stage 1: Store partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers to 0
            for (i = 0; i < size; i = i + 1) begin
                pipeline_stage_1[i] <= 0;
            end
        end else begin
            // Store partial products into pipeline stage 1
            for (i = 0; i < size; i = i + 1) begin
                pipeline_stage_1[i] <= partial_product[i];
            end
        end
    end

    // Pipeline Stage 2: Sum up all partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the stage 2 register to 0
            pipeline_stage_2 <= 0;
        end else begin
            // Perform summation of partial products and store in stage 2
            pipeline_stage_2 <= pipeline_stage_1[0] + 
                                pipeline_stage_1[1] + 
                                pipeline_stage_1[2] + 
                                pipeline_stage_1[3];
        end
    end

    // Final Output Stage: Store the final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the output to 0
            mul_out <= 0;
        end else begin
            // Update the output with the calculated final product
            mul_out <= pipeline_stage_2;
        end
    end

endmodule