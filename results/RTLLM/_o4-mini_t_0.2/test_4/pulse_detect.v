module pulse_detect(
    input        clk,
    input        rst_n,
    input        data_in,
    output reg   data_out
);

  // state encoding
  localparam [1:0]
    S0 = 2'd0,  // waiting for rising edge (data_in == 0)
    S1 = 2'd1,  // saw data_in == 1, waiting for it to return to 0
    S2 = 2'd2;  // final state: we’ve seen 0→1→0

  reg [1:0] state;

  // sequential FSM & output logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state    <= S0;
      data_out <= 1'b0;
    end
    else begin
      // default: no pulse unless we’re in S2
      data_out <= 1'b0;

      case(state)
        //----------------------------------------------------
        // S0: idle, waiting for a ‘1’ with data_in=0
        S0: begin
          if (data_in)
            state <= S1;
          else
            state <= S0;
        end

        //----------------------------------------------------
        // S1: saw a ‘1’, waiting for it to fall back to ‘0’
        S1: begin
          if (!data_in)
            state <= S2;
          else
            state <= S1;
        end

        //----------------------------------------------------
        // S2: final 0 of the 0→1→0 pattern; assert pulse
        S2: begin
          data_out <= 1'b1;        // one‐cycle pulse
          if (data_in)
            state <= S1;           // if it immediately goes high, treat as new S1
          else
            state <= S0;           // else return to idle
        end

        default: state <= S0;
      endcase
    end
  end

endmodule