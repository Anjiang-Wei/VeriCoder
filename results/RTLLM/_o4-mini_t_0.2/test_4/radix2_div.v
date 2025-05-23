module radix2_div(
    input  wire        clk,
    input  wire        rst,        // synchronous reset
    input  wire [7:0]  dividend,   // dividend operand
    input  wire [7:0]  divisor,    // divisor operand
    input  wire        sign,       // 1 = signed, 0 = unsigned
    input  wire        opn_valid,  // start operation
    output reg         res_valid,  // result ready
    input  wire        res_ready,  // consumer ready
    output wire [15:0] result      // { remainder[7:0], quotient[7:0] }
);

  // State machine
  localparam IDLE = 2'd0,
             DIV  = 2'd1,
             DONE = 2'd2;

  reg [1:0]        state;
  reg [7:0]        divd_abs, divs_abs;
  reg              divd_sign, divs_sign;
  reg              q_sign,   r_sign;
  reg [8:0]        rem;       // 9-bit to allow subtraction test
  reg [7:0]        quo;       // shifting quotient
  reg [3:0]        cnt;       // counts from 0..8

  // Combinational two's‑complement correction
  wire [7:0] quo_mag = quo;
  wire [7:0] rem_mag = rem[7:0];

  wire [7:0] quo_final = sign
                          ? (q_sign ? (~quo_mag + 8'd1) : quo_mag)
                          : quo_mag;

  wire [7:0] rem_final = sign
                          ? (r_sign ? (~rem_mag + 8'd1) : rem_mag)
                          : rem_mag;

  assign result = { rem_final, quo_final };

  // Main FSM
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state     <= IDLE;
      res_valid <= 1'b0;
      rem       <= 9'd0;
      quo       <= 8'd0;
      cnt       <= 4'd0;
    end else begin
      case(state)
        //----------------------------------------------------------------
        IDLE: begin
          res_valid <= 1'b0;
          if (opn_valid) begin
            // Capture signs
            divd_sign <= dividend[7];
            divs_sign <= divisor [7];
            // Compute magnitudes
            if (sign) begin
              // signed mode
              divd_abs <= dividend[7] ? (~dividend + 8'd1) : dividend;
              divs_abs <= divisor [7] ? (~divisor  + 8'd1) : divisor;
              q_sign   <= dividend[7] ^ divisor[7];
              r_sign   <= dividend[7];
            end else begin
              // unsigned mode
              divd_abs <= dividend;
              divs_abs <= divisor;
              q_sign   <= 1'b0;
              r_sign   <= 1'b0;
            end
            // Initialize partial remainder and quotient
            rem <= 9'd0;
            quo <= dividend; // we'll shift out bits from MSB down
            cnt <= 4'd0;
            state <= DIV;
          end
        end

        //----------------------------------------------------------------
        DIV: begin
          // shift left (rem,quo), bring MSB of quo into LSB of rem
          rem <= { rem[7:0], quo[7] };
          quo <= { quo[6:0], 1'b0 };

          // trial subtract divisor magnitude
          if ({1'b0, rem[7:0]} >= {1'b0, divs_abs}) begin
            rem <= {1'b0, rem[7:0]} - {1'b0, divs_abs};
            quo[0] <= 1'b1;
          end else begin
            quo[0] <= 1'b0;
          end

          // advance bit counter
          cnt <= cnt + 4'd1;
          if (cnt == 4'd8) begin
            state <= DONE;
          end
        end

        //----------------------------------------------------------------
        DONE: begin
          res_valid <= 1'b1;
          // wait for consumer to latch the result
          if (res_ready) begin
            res_valid <= 1'b0;
            state     <= IDLE;
          end
        end

      endcase
    end
  end

endmodule