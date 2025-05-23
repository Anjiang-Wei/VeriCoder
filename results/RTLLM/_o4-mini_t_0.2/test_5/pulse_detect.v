module pulse_detect(
    input        clk,
    input        rst_n,    // active low reset
    input        data_in,
    output reg   data_out
);

  // State encoding
  localparam IDLE   = 2'b00,
             HIGH   = 2'b01,
             DETECT = 2'b10;

  reg [1:0] state;

  // Synchronous FSM with async reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset all
      state    <= IDLE;
      data_out <= 1'b0;
    end else begin
      // default output each clock
      data_out <= 1'b0;

      case (state)
        IDLE: begin
          // wait for rising edge
          if (data_in)
            state <= HIGH;
          else
            state <= IDLE;
        end

        HIGH: begin
          // saw one 1 so far
          if (!data_in) begin
            // exact 0->1->0 sequence completed
            state    <= DETECT;
            data_out <= 1'b1;
          end else begin
            // still high on second cycle -> abort pulse
            state <= IDLE;
          end
        end

        DETECT: begin
          // just flagged the pulse; now go back to IDLE
          // or re‑enter HIGH if input remains 1
          if (data_in)
            state <= HIGH;
          else
            state <= IDLE;
        end

        default: begin
          state    <= IDLE;
          data_out <= 1'b0;
        end
      endcase
    end
  end

endmodule