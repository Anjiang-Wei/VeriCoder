module multi_16bit(
    input         clk,          // Chip clock signal.
    input         rst_n,        // Active-low reset signal. 0 resets the chip.
    input         start,        // Start signal to initiate multiplication.
    input  [15:0] ain,          // Multiplicand (a) 16-bit.
    input  [15:0] bin,          // Multiplier (b) 16-bit.
    
    output [31:0] yout,         // Product output 32-bit.
    output        done          // Completion flag. 1 indicates multiplication is complete.
);

  // Internal registers.
  reg [4:0] i;             // Shift count register. Counts 0 to 17.
  reg done_r;              // Internal done flag.
  reg [15:0] areg;         // Internal copy of multiplicand.
  reg [15:0] breg;         // Internal copy of multiplier.
  reg [31:0] yout_r;       // Accumulator register for the product.

  // Assign outputs.
  assign yout = yout_r;
  assign done = done_r;

  // Part 1: Shift count register i
  // This always block updates the count used to select which bit of the multiplicand is examined.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      i <= 5'd0;
    else if (!start)
      i <= 5'd0;
    else if (i < 5'd17)
      i <= i + 1'b1;
    else
      i <= i;  // Hold current value if i>=17.
  end

  // Part 2: Completion flag generation
  // The done flag is set when i equals 16 and cleared when i reaches 17.
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

  // Part 3: Shift and accumulate operation.
  // On the first cycle (i==0) when start is asserted, load the inputs into registers.
  // On subsequent cycles, for i=1 to 16, if bit (i-1) of the multiplicand is high then add  
  // the shifted multiplier value to the product accumulator.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end
    else begin
      if (start) begin
        if (i == 5'd0) begin
          // Initialization: store input values into registers.
          areg   <= ain;
          breg   <= bin;
          yout_r <= 32'd0;
        end
        else if (i < 5'd17) begin
          // For current shift count i=1 to 16, if the (i-1)th bit of areg is 1, then add
          // breg shifted left by (i-1) positions.
          if (areg[i-1]) begin
            yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
          end
          else begin
            yout_r <= yout_r;  // No addition if the bit is 0.
          end
        end
      end
      // When start is not asserted, registers remain unchanged.
    end
  end

endmodule