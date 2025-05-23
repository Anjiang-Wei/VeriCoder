module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [4:0] state;
parameter S0 = 5'b00001, S1 = 5'b00010, S2 = 5'b00100, S3 = 5'b01000, S4 = 5'b10000;

always @(posedge CLK or posedge RST) begin
  if (RST) begin
    MATCH <= 1'b0;
    state <= S0;
  end else begin
    case (state)
      S0: if (IN) state <= S1;
      S1: if (!IN) state <= S2;
      S2: if (IN) state <= S3;
      S3: if (!IN) state <= S4;
      S4: if (IN) begin state <= S0; MATCH <= 1'b1; end
    endcase
  end
end
endmodule