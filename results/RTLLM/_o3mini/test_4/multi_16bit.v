module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active‐low reset signal.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Multiplicand (a) – 16 bits.
    input [15:0] bin,   // Multiplier (b) – 16 bits.
    
    output [31:0] yout, // Product output – 32 bits.
    output done         // Completion flag: 1 if multiplication is finished.
);

  // Internal registers.
  // 'i' counts from 0 to 17. Need 5 bits to count up to 17.
  reg [4:0] i;
  
  // Registers to hold intermediate values.
  reg [15:0] areg, breg;       // Registers for multiplicand and multiplier.
  reg [31:0] yout_r;           // Accumulated product register.
  reg        done_r;           // Internal done flag.

  // =======================================================================
  // Data Bit Control: shift count register.
  // =======================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      i <= 5'd0;
    else if (start) begin
      if(i < 5'd17)
        i <= i + 1;
      else
        i <= i; // Maintain the value if it has reached 17.
    end
    else
      i <= 5'd0;
  end
  
  // =======================================================================
  // Multiplication Completion Flag Generation.
  // =======================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      done_r <= 1'b0;
    else if (i == 5'd16)
      done_r <= 1'b1;
    else if (i == 5'd17)
      done_r <= 1'b0;
    else
      done_r <= done_r; // Hold the current state.
  end
  
  // =======================================================================
  // Shift and Accumulate Operation.
  // =======================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end
    else if (start) begin
      if (i == 5'd0) begin
        // At the start, load the multiplicand and multiplier.
        areg   <= ain;
        breg   <= bin;
        yout_r <= 32'd0;
      end
      else if (i > 5'd0 && i < 5'd17) begin
        // For each bit position, if the (i-1)th bit in areg is high,
        // then accumulate the shifted multiplier.
        if (areg[i-1])
          // Extend breg to 32 bits, shift left by (i-1) positions,
          // and add the result into the product accumulator.
          yout_r <= yout_r + ({16'd0, breg} << (i - 1));
      end
    end
  end

  // =======================================================================
  // Output assignments.
  // =======================================================================
  assign yout = yout_r;
  assign done = done_r;

endmodule