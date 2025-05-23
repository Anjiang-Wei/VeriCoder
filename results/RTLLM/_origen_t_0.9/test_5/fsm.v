module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [2:0] state;
parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100;

always @(IN or CLK or RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end
    else begin
        case (state)
            S0: begin
                if (IN) state <= S1;
                else state <= S0;
                MATCH <= 0;
            end
            S1: begin
                if (~IN) state <= S2;
                else state <= S1;
                MATCH <= 0;
            end
            S2: begin
                if (~IN) state <= S3;
                else state <= S1;
                MATCH <= 0;
            end
            S3: begin
                if (IN) state <= S4;
                else state <= S0;
                MATCH <= 0;
            end
            S4: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 1;
                end
                else begin
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