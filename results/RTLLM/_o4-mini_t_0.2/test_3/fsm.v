module fsm(
  input  wire IN,
  input  wire CLK,
  input  wire RST,
  output reg  MATCH
);

  // State encoding
  localparam S0 = 3'b000,  // no bits seen
             S1 = 3'b001,  // seen “1”
             S2 = 3'b010,  // seen “1 0”
             S3 = 3'b011,  // seen “1 0 0”
             S4 = 3'b100;  // seen “1 0 0 1”

  reg [2:0] state;

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      state <= S0;
      MATCH <= 1'b0;
    end else begin
      // default MATCH=0 every cycle; set to 1 only on the Mealy transition
      MATCH <= 1'b0;
      case (state)
        S0: begin
          if (IN) state <= S1;
          else     state <= S0;
        end
        S1: begin
          if (IN) state <= S1;   // “1 1” → stay in S1 (the new 1 could start a new seq)
          else     state <= S2;   // “1 0”
        end
        S2: begin
          if (IN) state <= S1;   // “1 0 1” → suffix “1”
          else     state <= S3;   // “1 0 0”
        end
        S3: begin
          if (IN) state <= S4;   // “1 0 0 1”
          else     state <= S0;   // “1 0 0 0” → no prefix
        end
        S4: begin
          if (IN) begin           // final “1” of “1 0 0 1 1”
            state <= S1;          // suffix “1”
            MATCH <= 1'b1;        // Mealy output
          end else begin         // got “1 0 0 1 0”
            state <= S2;          // suffix “1 0”
          end
        end
        default: state <= S0;
      endcase
    end
  end

endmodule