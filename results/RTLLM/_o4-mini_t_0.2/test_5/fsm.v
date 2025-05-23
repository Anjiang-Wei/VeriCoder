module fsm(
    input  wire IN,    // serial bit‐stream in
    input  wire CLK,   // system clock
    input  wire RST,   // synchronous reset, active high
    output reg  MATCH  // pulses when “10011” is seen
);

  // state encoding
  localparam S0 = 3'd0;  // no bits matched
  localparam S1 = 3'd1;  // matched “1”
  localparam S2 = 3'd2;  // matched “10”
  localparam S3 = 3'd3;  // matched “100”
  localparam S4 = 3'd4;  // matched “1001”

  reg [2:0] state, next_state;

  // sequential state + output update
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      state <= S0;
      MATCH <= 1'b0;
    end else begin
      state <= next_state;
      // Mealy output: when we were in S4 and see IN=1, we've seen 10011
      MATCH <= (state == S4 && IN);
    end
  end

  // combinational next‐state logic
  always @(*) begin
    case (state)
      S0: next_state = IN ? S1 : S0;
      S1: next_state = IN ? S1 : S2;
      S2: next_state = IN ? S1 : S3;
      S3: next_state = IN ? S4 : S0;
      S4:               // after 1001
           if (IN)      // see final '1' → match, but suffix '1' can be start of next
             next_state = S1;
           else         // see '0' → suffix "10" is prefix of the pattern
             next_state = S2;
      default: next_state = S0;
    endcase
  end

endmodule