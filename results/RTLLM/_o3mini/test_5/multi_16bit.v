module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Multiplicand (a)
    input [15:0] bin,   // Multiplier (b)

    output [31:0] yout, // Product output.
    output done         // Completion flag; 1 = multiplication complete.
);

  // Internal registers.
  // "i" counts the number of accumulated shifts. It must count from 0 to 17.
  reg [4:0] i;
  reg [15:0] areg;    // Register to hold the multiplicand.
  reg [15:0] breg;    // Register to hold the multiplier.
  reg [31:0] yout_r;  // Product register.
  reg done_r;         // Done flag register.

  // Output assignments.
  assign yout = yout_r;
  assign done = done_r;

  //
  // Shift count register update
  //
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      i <= 0;
    else if (!start)
      i <= 0;
    else if (start && (i < 5'd17))
      i <= i + 1;
    else
      i <= i;  // Hold current value if not incrementing.
  end

  //
  // Multiplication done flag generation
  //
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      done_r <= 1'b0;
    else begin
      if(i == 5'd16)
        done_r <= 1'b1;
      else if (i == 5'd17)
        done_r <= 1'b0;
      else
        done_r <= done_r;
    end
  end

  //
  // Shift and Accumulate Operation
  //
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end
    else if(start) begin
      if(i == 5'd0) begin
        // On the first cycle, load the registers.
        areg   <= ain;
        breg   <= bin;
        yout_r <= 32'd0;
      end
      else if(i > 5'd0 && i < 5'd17) begin
        // For each subsequent cycle check the bit (i-1) of the stored multiplicand.
        // If it is high, add the shifted multiplier to the product register.
        // Shifting breg to left by (i-1) positions.
        if(areg[i-1]) 
          yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
        else
          yout_r <= yout_r; // No change if the bit is low.
      end
    end
    // When start is inactive, no update to areg, breg, yout_r is done.
  end

endmodule