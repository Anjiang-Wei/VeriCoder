module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk, // Clock input
    input rst_n, // Active low reset signal
    input i_en, // Enable signal for addition operation
    input [DATA_WIDTH-1:0] adda, // Input operand A (64-bit)
    input [DATA_WIDTH-1:0] addb, // Input operand B (64-bit)
    output reg [DATA_WIDTH+STG_WIDTH:0] result, // Output representing sum of adda and addb
    output o_en // Output enable signal
);

// Pipeline stages
reg [DATA_WIDTH+STG_WIDTH-1:0] stage_in;
reg [DATA_WIDTH+STG_WIDTH-1:0] stage_out;

reg [DATA_WIDTH+STG_WIDTH:0] carry; // Carry signals for pipeline stages

// Registers to synchronize input enable signal and output result
reg i_en_synchronized, o_en_synchronized;

always @ (posedge clk) begin
    if (~rst_n) begin
        stage_in <= 0;
        stage_out <= 0;
        carry <= 0;
        i_en_synchronized <= 0;
        o_en_synchronized <= 0;
    end else begin
        if (i_en) begin
            // Synchronize input enable signal
            i_en_synchronized <= i_en;

            // Calculate sum and carry for each pipeline stage
            carry[DATA_WIDTH+STG_WIDTH-1:0] = {stage_in[DATA_WIDTH-1], adda, addb};
            result[DATA_WIDTH+STG_WIDTH-1:0] = stage_in + carry;
        end

        if (o_en_synchronized) begin
            // Update output enable signal based on pipeline stages
            o_en <= o_en_synchronized;

            // Forward sum and carry to next pipeline stage
            stage_out <= result[DATA_WIDTH+STG_WIDTH-1:0];
            stage_in <= result;
        end else begin
            // Initialize output enable signal
            o_en_synchronized <= 1;

            // Forward sum and carry to next pipeline stage
            stage_out <= {32'd0, adda};
            stage_in <= stage_out + {addb, 32'd0};
        end
    end
end

// Output the result after all pipeline stages have been processed
always @ (posedge clk) begin
    if (~rst_n && o_en_synchronized) begin
        // The sum is available on the output port when the last stage has finished processing
        result <= result[DATA_WIDTH+STG_WIDTH-1:0];
    end
end

// Assign output enable signal to final value after pipeline stages have been processed
always @ (posedge clk) begin
    if (~rst_n && o_en_synchronized) begin
        // Output enable signal is set when the last stage has finished processing
        o_en <= 1;
    end else begin
        // Reset output enable signal on reset or when pipeline stages are not enabled
        o_en <= 0;
    end
end

// Assign result to output port after all pipeline stages have been processed
always @ (posedge clk) begin
    if (~rst_n && o_en_synchronized) begin
        // The sum is available on the output port when the last stage has finished processing
        result <= {result, 1'b0};
    end else begin
        // Reset result to zero on reset or when pipeline stages are not enabled
        result <= 0;
    end
end

endmodule