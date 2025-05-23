module multi_pipe_8bit#(
    parameter size = 8
)(
    input clk,                    // Clock signal
    input rst_n,                  // Active-low reset signal
    input mul_en_in,              // Input enable signal
    input [size-1:0] mul_a,       // Multiplicand (8-bit)
    input [size-1:0] mul_b,       // Multiplier (8-bit)
    
    output reg mul_en_out,        // Output enable signal
    output reg [size*2-1:0] mul_out // Product output (16-bit)
);

    // Pipeline stage registers for input enable and operand values
    reg mul_en_pipe1, mul_en_pipe2; // Enable signal pipeline registers
    reg [size-1:0] mul_a_pipe1, mul_b_pipe1; // Stage 1 pipeline registers for inputs
    reg [size-1:0] mul_a_pipe2, mul_b_pipe2; // Stage 2 pipeline registers for inputs
    
    // Intermediate registers for partial product computation
    reg [size*2-1:0] partial_product_pipe1; // Stage 1 partial product register
    reg [size*2-1:0] partial_product_pipe2; // Stage 2 partial product register

    // Reset and Clock-based Sequential Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            mul_en_pipe1 <= 1'b0;
            mul_en_pipe2 <= 1'b0;
            mul_a_pipe1  <= {size{1'b0}};
            mul_b_pipe1  <= {size{1'b0}};
            mul_a_pipe2  <= {size{1'b0}};
            mul_b_pipe2  <= {size{1'b0}};
            partial_product_pipe1 <= {(size*2){1'b0}};
            partial_product_pipe2 <= {(size*2){1'b0}};
            mul_en_out   <= 1'b0;
            mul_out      <= {(size*2){1'b0}};
        end
        else begin
            // Pipeline Stage 1: Capture inputs and enable signal
            mul_en_pipe1 <= mul_en_in;
            mul_a_pipe1 <= mul_a;
            mul_b_pipe1 <= mul_b;

            // Pipeline Stage 1: Calculate initial partial product
            partial_product_pipe1 <= mul_a_pipe1 * mul_b_pipe1;
            
            // Pipeline Stage 2: Pass values to next stage
            mul_en_pipe2 <= mul_en_pipe1;
            mul_a_pipe2 <= mul_a_pipe1;
            mul_b_pipe2 <= mul_b_pipe1;
            partial_product_pipe2 <= partial_product_pipe1;

            // Final Stage: Output enable and product
            mul_en_out <= mul_en_pipe2;
            mul_out <= partial_product_pipe2; // Final product output
        end
    end

endmodule