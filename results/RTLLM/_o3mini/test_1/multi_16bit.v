module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. 0 = reset active.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Multiplicand input (16 bits)
    input [15:0] bin,   // Multiplier input (16 bits)
    
    output [31:0] yout, // Multiplication product (32 bits)
    output done         // Done flag: 1 indicates completion
);

  // Internal registers
  // 'i' is the shift count (needs to count up to 17, so 5 bits are used)
  reg [4:0] i;

  // Registers to hold the multiplicand, multiplier and product.
  reg [15:0] areg, breg;
  reg [31:0] yout_r;

  // Register to hold the done flag.
  reg done_r;

  //***********************************************************************
  // Shift count register update
  //***********************************************************************
  //
  // On every positive clock edge or negative reset:
  // - Reset (rst_n low): i is set to 0.
  // - If start is high and i < 17, then i increments.
  // - If start is low, then i resets to 0.
  //
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      i <= 0;
    else if (start) begin
      if (i < 5'd17)
        i <= i + 1'b1;
      else
        i <= i;  // stay at current count if somehow it passes the limit
    end
    else begin
      i <= 0;
    end
  end

  //***********************************************************************
  // Multiplication completion flag generation
  //***********************************************************************
  //
  // On every positive clock edge or negative reset:
  // - Reset (rst_n low): done_r is cleared.
  // - When shift count i equals 16, done_r is set to 1.
  // - When shift count i equals 17, done_r is cleared.
  //
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      done_r <= 1'b0;
    else if (i == 5'd16)
      done_r <= 1'b1;
    else if (i == 5'd17)
      done_r <= 1'b0;
    else
      done_r <= done_r;
  end

  //***********************************************************************
  // Shift and accumulate operation
  //***********************************************************************
  //
  // On every positive clock edge or negative reset:
  // - Reset (rst_n low): areg, breg, and yout_r are cleared.
  // - When start is active:  
  //     - For i == 0, load the inputs into areg and breg, and initialize yout_r.
  //     - For i > 0 and i < 17, check if bit (i-1) of areg is 1. If so, 
  //       accumulate the value (breg shifted left by (i-1)) into yout_r.
  //
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end
    else if (start) begin
      if (i == 5'd0) begin
        // At the first cycle, load the inputs into registers
        areg   <= ain;
        breg   <= bin;
        yout_r <= 32'd0;
      end
      else if ((i > 0) && (i < 5'd17)) begin
        // For bit position i-1 in the multiplicand:
        // If it is high, add the multiplier shifted left by (i-1)
        if (areg[i-1])
          yout_r <= yout_r + ({{16{1'b0}}, breg} << (i-1));
        else
          yout_r <= yout_r;
      end
    end
    else begin
      // When start is not active, clear registers (optional based on design)
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end
  end

  //
  // Output assignments
  //
  assign yout = yout_r;
  assign done = done_r;

endmodule