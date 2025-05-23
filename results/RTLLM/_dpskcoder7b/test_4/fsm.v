module fsm(IN,MATCH,CLK,RST);
    input IN,CLK,RST;
    output reg MATCH;
    
    reg [4:0] state, next_state;
    parameter IDLE = 5'b00001,
              ZERO = 5'b00010,
              ZER0 = 5'b00100,
              ZER1 = 5'b01000,
              MATCH_STATE = 5'b10000;
    
    always @ (posedge CLK or posedge RST) begin
        if (RST) begin
            state <= IDLE;
            MATCH <= 0;
        end
        else begin
            state <= next_state;
            case (state)
                IDLE: if (IN == 1'b1) next_state = ZERO;
                      else next_state = IDLE;
                ZERO: if (IN == 1'b0) next_state = ZER0;
                      else next_state = IDLE;
                ZER0: if (IN == 1'b0) next_state = ZER1;
                      else next_state = IDLE;
                ZER1: if (IN == 1'b1) next_state = MATCH_STATE;
                      else next_state = IDLE;
                MATCH_STATE: next_state = IDLE;
                default: next_state = IDLE;
            endcase
        end
    end
    
    always @ (state) begin
        case (state)
            MATCH_STATE: MATCH = 1'b1;
            default: MATCH = 1'b0;
        endcase
    end
endmodule