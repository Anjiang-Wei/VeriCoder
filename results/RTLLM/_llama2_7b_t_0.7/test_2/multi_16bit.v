module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

  // Data bit control
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i <= 0;
      done_r <= 0;
    end else begin
      if (start && i < 17) begin
        i <= i + 1;
      end else begin
        i <= 0;
        done_r <= 0;
      end
    end
  end

  // Multiplication completion flag generation
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done_r <= 0;
    end else begin
      if (i == 16) begin
        done_r <= 1;
      end else begin
        done_r <= 0;
      end
    end
  end

  // Shift and accumulate operation
  always @*begin
    if (start && i < 17) begin
      // Multiplicand and multiplier registers
      areg <= ain;
      breg <= bin;

      // Product register
      yout_r <= breg << (i-1);

      // Output assignment
      yout <= yout_r;
    end else begin
      areg <= 0;
      breg <= 0;
      yout_r <= 0;
    end
  end

  assign done = done_r;
endmodule