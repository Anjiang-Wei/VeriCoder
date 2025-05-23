module radix2_div(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  dividend,
    input  wire [7:0]  divisor,
    input  wire        sign,        // 1 = signed op, 0 = unsigned
    input  wire        opn_valid,
    output reg         res_valid,
    input  wire        res_ready,
    output wire [15:0] result        // { remainder[7:0], quotient[7:0] }
);

  // Internal registers
  reg        start;               // Division in progress
  reg [3:0]  cnt;                 // Cycle counter 0..8
  reg [8:0]  r;                   // 9‐bit partial remainder
  reg [7:0]  dividend_buf;        // shifting dividend bits
  reg [7:0]  divisor_buf;         // absolute divisor
  reg [7:0]  abs_dividend;        // absolute dividend
  reg        sign_dividend;       // original dividend sign
  reg        sign_divisor;        // original divisor sign
  reg        sign_q_out;          // quotient sign out
  reg [7:0]  q;                   // building quotient bits
  reg [7:0]  q_out;               // final quotient
  reg [7:0]  rem_out;             // final remainder
  reg [8:0]  trial;               // trial subtraction result

  // Pack the result
  assign result = { rem_out, q_out };

  always @(posedge clk) begin
    if (rst) begin
      // synchronous reset
      res_valid     <= 1'b0;
      start         <= 1'b0;
      cnt           <= 4'd0;
      r             <= 9'd0;
      dividend_buf  <= 8'd0;
      divisor_buf   <= 8'd0;
      abs_dividend  <= 8'd0;
      sign_dividend <= 1'b0;
      sign_divisor  <= 1'b0;
      sign_q_out    <= 1'b0;
      q             <= 8'd0;
      q_out         <= 8'd0;
      rem_out       <= 8'd0;
    end else begin
      // clear result valid when consumer is ready
      if (res_valid && res_ready)
        res_valid <= 1'b0;

      // Step through division cycles
      if (start) begin
        // SHIFT LEFT: bring in next dividend bit
        r = { r[7:0], dividend_buf[7] };   // drop MSB of r, shift left, LSB = next dividend bit
        dividend_buf <= dividend_buf << 1;

        // trial = r - divisor
        trial = r - {1'b0, divisor_buf};

        // if trial >= 0 -> accept subtraction and set quotient bit to 1
        if (!trial[8]) begin
          r = trial;
          q[cnt] <= 1'b1;
        end else begin
          // trial < 0 -> restore r, quotient bit = 0
          q[cnt] <= 1'b0;
        end

        // increment step counter
        if (cnt == 4'd7) begin
          // Last iteration done, produce final outputs
          start <= 1'b0;

          // r holds unsigned remainder, q holds unsigned quotient
          // apply sign correction if in signed mode
          if (sign && sign_dividend) begin
            // make remainder negative if dividend was negative
            rem_out <= -r[7:0];
          end else begin
            rem_out <= r[7:0];
          end

          if (sign_q_out) begin
            q_out <= -q;
          end else begin
            q_out <= q;
          end

          // signal result ready
          res_valid <= 1'b1;
        end else begin
          cnt <= cnt + 1'b1;
        end

      end else begin
        // Idle: start a new operation when requested
        if (!res_valid && opn_valid) begin
          // capture inputs
          sign_dividend  <= sign & dividend[7];
          sign_divisor   <= sign & divisor[7];
          abs_dividend   <= sign & dividend[7] ? -dividend : dividend;
          abs_divisor    <= sign & divisor[7]  ? -divisor  : divisor;
          sign_q_out     <= (sign & dividend[7]) ^ (sign & divisor[7]);
          dividend_buf   <= sign & dividend[7] ? -dividend : dividend;
          divisor_buf    <= sign & divisor[7]  ? -divisor  : divisor;
          r              <= 9'd0;
          q              <= 8'd0;
          cnt            <= 4'd0;
          start          <= 1'b1;
          // clear old outputs
          res_valid      <= 1'b0;
        end
      end
    end
  end

endmodule