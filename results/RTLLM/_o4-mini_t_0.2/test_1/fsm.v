module fsm(
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

  // state encoding
  localparam S0 = 3'd0;  // no bits seen
  localparam S1 = 3'd1;  // seen "1"
  localparam S2 = 3'd2;  // seen "10"
  localparam S3 = 3'd3;  // seen "100"
  localparam S4 = 3'd4;  // seen "1001"

  reg [2:0] state;

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      state <= S0;
      MATCH <= 1'b0;
    end
    else begin
      // default for this cycle
      MATCH <= 1'b0;
      case (state)
        S0: begin
          if (IN) state <= S1;
          else     state <= S0;
        end

        S1: begin
          if (IN) state <= S1;   // "11" → keep only last '1'
          else     state <= S2;  // "10"
        end

        S2: begin
          if (IN) state <= S1;   // "101" → suffix '1'
          else     state <= S3;  // "100"
        end

        S3: begin
          if (IN) state <= S4;   // "1001"
          else     state <= S0;  // "1000" → no prefix
        end

        S4: begin
          if (IN) begin
            // full pattern 1-0-0-1-1 seen
            MATCH <= 1'b1;
            state <= S1;        // overlap via suffix '1'
          end
          else begin
            // saw "10010"
            state <= S2;        // overlap via suffix "10"
          end
        end

        default: begin
          state <= S0;
        end
      endcase
    end
  end

endmodule