module multi_pipe_8bit #(
    parameter size = 8
)(
    input clk,            // Clock signal
    input rst_n,          // Active-low reset signal
    input mul_en_in,      // Input enable signal
    input [size-1:0] mul_a, // Multiplicand
    input [size-1:0] mul_b, // Multiplier
    
    output reg mul_en_out, // Output enable signal
    output reg [size*2-1:0] mul_out // Product output
);

  // Internal pipeline registers to store intermediate values
  reg [size-1:0] mul_a_reg [1:0]; // Pipeline stages for multiplicand
  reg [size-1:0] mul_b_reg [1:0]; // Pipeline stages for multiplier
  reg [size*2-1:0] partial_sum [1:0]; // To store partial sums at each stage
  reg mul_en_reg [1:0];              // Pipeline registers for enable signal

  // Reset behavior and pipeline control
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset all pipeline registers to 0
      mul_a_reg[0] <= 0;
      mul_b_reg[0] <= 0;
      partial_sum[0] <= 0;
      mul_en_reg[0] <= 0;

      mul_a_reg[1] <= 0;
      mul_b_reg[1] <= 0;
      partial_sum[1] <= 0;
      mul_en_reg[1] <= 0;

      mul_en_out <= 0;
      mul_out <= 0;
    end else begin
      // Stage 1: Capture inputs and partial products
      if (mul_en_in) begin
        mul_a_reg[0] <= mul_a;
        mul_b_reg[0] <= mul_b;
        partial_sum[0] <= mul_a * mul_b; // Compute full multiplication
        mul_en_reg[0] <= mul_en_in;
      end else begin
        mul_en_reg[0] <= 0;
      end

      // Stage 2: Pipeline forwarding
      mul_a_reg[1] <= mul_a_reg[0];
      mul_b_reg[1] <= mul_b_reg[0];
      partial_sum[1] <= partial_sum[0]; // Forward partial product
      mul_en_reg[1] <= mul_en_reg[0];

      // Final output stage
      mul_out <= partial_sum[1];
      mul_en_out <= mul_en_reg[1];
    end
  end

endmodule