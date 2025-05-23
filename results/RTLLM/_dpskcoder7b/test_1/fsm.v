module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [4:0] state;
parameter S0 = 5'b00000, S1 = 5'b00001, S2 = 5'b00010, S3 = 5'b00100, S4 = 5'b01000, S5 = 5'b10000;

always @(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        state <= S0;
        MATCH <= 1'b0;
    end
    else
    begin
        case(state)
            S0:
            begin
                if(IN)
                begin
                    state <= S1;
                    MATCH <= 1'b0;
                end
            end
            S1:
            begin
                if(IN)
                begin
                    state <= S2;
                    MATCH <= 1'b0;
                end
                else
                begin
                    state <= S0;
                end
            end
            S2:
            begin
                if(IN)
                begin
                    state <= S3;
                    MATCH <= 1'b0;
                end
                else
                begin
                    state <= S1;
                end
            end
            S3:
            begin
                if(IN)
                begin
                    state <= S4;
                    MATCH <= 1'b0;
                end
                else
                begin
                    state <= S2;
                end
            end
            S4:
            begin
                if(IN)
                begin
                    state <= S5;
                    MATCH <= 1'b1;
                end
                else
                begin
                    state <= S3;
                end
            end
            S5:
            begin
                if(IN)
                begin
                    state <= S0;
                    MATCH <= 1'b1;
                end
            end
            default:
            begin
                state <= S0;
                MATCH <= 1'b0;
            end
        endcase
    end
end
endmodule