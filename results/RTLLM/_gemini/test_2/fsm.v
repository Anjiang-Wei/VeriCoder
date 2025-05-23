module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

// State definition
reg [3:0] state;
parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0100;
parameter S4 = 4'b1000;
parameter S5 = 4'b1001;

// State transition and output logic
always @(posedge CLK or posedge RST) begin
  if (RST) begin
    state <= S0;
    MATCH <= 0;
  end else begin
    case (state)
      S0: begin
        if (IN == 1) begin
          state <= S1;
          MATCH <= 0;
        end else begin
          state <= S0;
          MATCH <= 0;
        end
      end
      S1: begin
        if (IN == 0) begin
          state <= S2;
          MATCH <= 0;
        end else begin
          state <= S1;
          MATCH <= 0;
        end
      end
      S2: begin
        if (IN == 0) begin
          state <= S3;
          MATCH <= 0;
        end else begin
          state <= S1;
          MATCH <= 0;
        end
      end
      S3: begin
        if (IN == 1) begin
          state <= S4;
          MATCH <= 0;
        end else begin
          state <= S3;
          MATCH <= 0;
        end
      end
      S4: begin
        if (IN == 1) begin
          state <= S5;
          MATCH <= 1;
        end else begin
          state <= S4;
          MATCH <= 0;
        end
      end
      S5: begin
        if (IN == 1) begin
          state <= S5;
          MATCH <= 1;
        end else begin
          state <= S0;
          MATCH <= 0;
        end
      end
      default: begin
        state <= S0;
        MATCH <= 0;
      end
    endcase
  end
end

endmodule