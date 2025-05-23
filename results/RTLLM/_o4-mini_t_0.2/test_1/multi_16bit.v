module multi_16bit(
    input           clk,    // Chip clock signal
    input           rst_n,  // Active‐low reset (0 = reset)
    input           start,  // Start multiplication when asserted
    input  [15:0]   ain,    // Multiplicand
    input  [15:0]   bin,    // Multiplier

    output [31:0]   yout,   // 32‐bit product
    output          done    // High for one cycle when product is ready
);

  //--------------------------------------------------------------------------
  // Internal registers
  //--------------------------------------------------------------------------

  reg [4:0]   i;         // shift count: 0..17
  reg         done_r;    // internal done flag
  reg [15:0]  areg;      // holds ain
  reg [15:0]  breg;      // holds bin
  reg [31:0]  yout_r;    // accumulation register

  //--------------------------------------------------------------------------
  // Shift‐count logic (i)
  //--------------------------------------------------------------------------
  // i = 0 on reset or when start is deasserted.
  // while start=1 and i<17, increment i each clock.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      i <= 5'd0;
    else if (!start)
      i <= 5'd0;
    else if (i < 5'd17)
      i <= i + 5'd1;
    else
      i <= i;      // hold at 17
  end

  //--------------------------------------------------------------------------
  // Done‐flag generation
  //--------------------------------------------------------------------------
  // done_r pulses high when i == 16, cleared when i == 17.
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

  //--------------------------------------------------------------------------
  // Shift‐and‐accumulate operation
  //--------------------------------------------------------------------------
  // At i==0: load ain→areg, bin→breg, clear yout_r.
  // For 1 <= i <= 16: if areg[i-1] == 1, add (breg << (i-1)) to yout_r.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end
    else if (start) begin
      case (i)
        5'd0: begin
          areg   <= ain;
          breg   <= bin;
          yout_r <= 32'd0;
        end

        // For shift positions 1..16
        default: begin
          // only accumulate when 1 <= i <= 16
          if (i >= 5'd1 && i <= 5'd16) begin
            if (areg[i-1]) begin
              // zero‐extend breg to 32 bits, shift by (i-1)
              yout_r <= yout_r + ({16'd0, breg} << (i-1));
            end
          end
          // else do nothing
        end
      endcase
    end
    // if start==0, hold previous registers until re‐started or reset
  end

  //--------------------------------------------------------------------------
  // Output assignments
  //--------------------------------------------------------------------------
  assign yout = yout_r;
  assign done = done_r;

endmodule