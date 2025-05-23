module multi_16bit(
    input           clk,       // Chip clock signal
    input           rst_n,     // Active-low reset (0 = reset)
    input           start,     // Start multiplication
    input  [15:0]   ain,       // Multiplicand
    input  [15:0]   bin,       // Multiplier
    output [31:0]   yout,      // 32-bit product
    output          done       // High when multiplication is complete
);

  //-------------------------------------------------------------------------
  // Internal registers
  //-------------------------------------------------------------------------
  reg [4:0]   i;        // shift count: 0..17
  reg [15:0]  areg;     // captured multiplicand
  reg [15:0]  breg;     // captured multiplier
  reg [31:0]  yout_r;   // partial product accumulator
  reg         done_r;   // internal done flag

  //-------------------------------------------------------------------------
  // 1) Shift-count register 'i'
  //    - on reset or !start -> 0
  //    - when start & i<17 -> i+1
  //-------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i <= 5'd0;
    end
    else if (!start) begin
      i <= 5'd0;
    end
    else if (i < 5'd17) begin
      i <= i + 5'd1;
    end
  end

  //-------------------------------------------------------------------------
  // 2) done flag generation
  //    - reset -> 0
  //    - when i==16 -> done=1
  //    - when i==17 -> done=0 (to allow re‑start)
  //-------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done_r <= 1'b0;
    end
    else if (i == 5'd16) begin
      done_r <= 1'b1;
    end
    else if (i == 5'd17) begin
      done_r <= 1'b0;
    end
  end

  //-------------------------------------------------------------------------
  // 3) Shift ‑ and ‑ accumulate logic
  //    - reset -> clear areg, breg, yout_r
  //    - when start:
  //         i==0  : capture ain, bin & clear accumulator
  //         1<=i<=16: if areg[i-1]==1 add (breg << (i-1)) to yout_r
  //-------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end
    else if (start) begin
      if (i == 5'd0) begin
        areg   <= ain;
        breg   <= bin;
        yout_r <= 32'd0;
      end
      else if (i <= 5'd16) begin
        // if the (i-1)th bit of areg is set, add shifted breg
        if (areg[i-1]) begin
          yout_r <= yout_r + ({16'b0, breg} << (i-1));
        end
      end
      // beyond i==16 we do nothing to yout_r
    end
  end

  //-------------------------------------------------------------------------
  // 4) Outputs
  //-------------------------------------------------------------------------
  assign yout = yout_r;
  assign done = done_r;

endmodule