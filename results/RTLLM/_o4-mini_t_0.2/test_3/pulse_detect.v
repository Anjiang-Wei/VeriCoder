module pulse_detect(    
    input        clk,
    input        rst_n,
    input        data_in,
    output reg   data_out
);

  // State encoding
  localparam [1:0]
    S0 = 2'b00,   // waiting for first '0'
    S1 = 2'b01,   // saw '0', waiting for '1'
    S2 = 2'b10;   // saw '01', waiting for trailing '0'

  reg [1:0] state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state    <= S0;
      data_out <= 1'b0;
    end else begin
      // default output
      data_out <= 1'b0;
      case (state)
        S0: begin
          if (data_in == 1'b0)
            state <= S1;
          else
            state <= S0;
        end

        S1: begin
          if (data_in == 1'b1)
            state <= S2;
          else
            state <= S1;
        end

        S2: begin
          if (data_in == 1'b0) begin
            // Completed 0->1->0 pattern
            data_out <= 1'b1;
            // That '0' could be the start of a new pulse
            state    <= S1;
          end else begin
            // saw '011' -- not a pulse, restart
            state <= S0;
          end
        end

        default: begin
          state    <= S0;
          data_out <= 1'b0;
        end
      endcase
    end
  end

endmodule