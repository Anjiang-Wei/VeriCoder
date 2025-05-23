module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;
    
    // Define the FSM states
    localparam IDLE = 3'b000,
               STATE1 = 3'b001,
               STATE2 = 3'b010,
               STATE3 = 3'b011,
               STATE4 = 3'b100,
               STATE5 = 3'b101,
               MATCH_FOUND = 3'b110;
    
    // State variable
    reg [2:0] state, next_state;
    
    // FSM state transitions
    always @(*) begin
        case(state)
            IDLE: begin
                if(RST) begin
                    next_state = IDLE;
                    MATCH = 0;
                end
                else if(IN == 1'b1) begin
                    next_state = STATE1;
                    MATCH = 0;
                end
                else begin
                    next_state = IDLE;
                    MATCH = 0;
                end
            end
            STATE1: begin
                if(IN == 1'b0) begin
                    next_state = STATE2;
                    MATCH = 0;
                end
                else begin
                    next_state = STATE1;
                    MATCH = 0;
                end
            end
            STATE2: begin
                if(IN == 1'b0) begin
                    next_state = STATE3;
                    MATCH = 0;
                end
                else begin
                    next_state = STATE1;
                    MATCH = 0;
                end
            end
            STATE3: begin
                if(IN == 1'b1) begin
                    next_state = STATE4;
                    MATCH = 0;
                end
                else begin
                    next_state = STATE1;
                    MATCH = 0;
                end
            end
            STATE4: begin
                if(IN == 1'b0) begin
                    next_state = STATE5;
                    MATCH = 0;
                end
                else begin
                    next_state = STATE1;
                    MATCH = 0;
                end
            end
            STATE5: begin
                if(IN == 1'b1) begin
                    next_state = MATCH_FOUND;
                    MATCH = 1;
                end
                else begin
                    next_state = STATE1;
                    MATCH = 0;
                end
            end
            MATCH_FOUND: begin
                next_state = MATCH_FOUND;
                MATCH = 1;
            end
            default: begin
                next_state = IDLE;
                MATCH = 0;
            end
        endcase
    end
    
    // Update state on positive edge of CLK
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
endmodule