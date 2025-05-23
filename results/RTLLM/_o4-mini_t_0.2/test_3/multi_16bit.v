module multi_16bit(
    input            clk,   // Chip clock signal.
    input            rst_n, // Active‐low reset signal. 0 = reset, 1 = normal.
    input            start, // Start multiplication.
    input  [15:0]    ain,   // Multiplicand.
    input  [15:0]    bin,   // Multiplier.
    output [31:0]    yout,  // Product.
    output           done   // High for one cycle when product is ready.
);

  //-------------------------------------------------------------------------
  // Internal registers
  //-------------------------------------------------------------------------
  reg [4:0]   i;        // shift/step counter: counts from 0..17
  reg         done_r;   // completion flag
  reg [15:0]  areg;     // holds multiplicand
  reg [15:0]  breg;     // holds multiplier
  reg [31:0]  yout_r;   // accumulator for partial products

  //-------------------------------------------------------------------------
  // 1) shift‐count (i) control
  //-------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i <= 5'd0;
    end else begin
      if (!start) begin
        i <= 5'd0;
      end else if (start && i < 5'd17) begin
        i <= i + 5'd1;
      end
      // else hold at 17
    end
  end

  //-------------------------------------------------------------------------
  // 2) done flag generation
  //    - done_r goes high exactly when i == 16
  //    - done_r is cleared when i == 17 (next cycle)
  //-------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done_r <= 1'b0;
    end else begin
      if (i == 5'd16)
        done_r <= 1'b1;
      else if (i == 5'd17)
        done_r <= 1'b0;
      // else hold
    end
  end

  //-------------------------------------------------------------------------
  // 3) shift‐and‐accumulate datapath
  //-------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      areg   <= 16'd0;
      breg   <= 16'd0;
      yout_r <= 32'd0;
    end else if (start) begin
      case (i)
        5'd0: begin
          // load multiplicand and multiplier, clear accumulator
          areg   <= ain;
          breg   <= bin;
          yout_r <= 32'd0;
        end
        default: begin
          // for 1 <= i <= 16, conditionally add shifted breg
          if ((i > 5'd0) && (i < 5'd17)) begin
            if (areg[i-1])
              yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
            else
              yout_r <= yout_r;
          end
          // areg and breg hold their values
        end
      endcase
    end
    // if start==0, registers just hold their values until reset
  end

  //-------------------------------------------------------------------------
  // 4) output assignments
  //-------------------------------------------------------------------------
  assign yout = yout_r;
  assign done = done_r;

endmodule