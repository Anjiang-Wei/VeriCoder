module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;

    // Define the states
    typedef enum logic [2:0] {
        START,
        S1,
        S2,
        S3,
        S4,
        MATCH
    } state_t;

    state_t state, next_state;

    // State register
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            state <= START;
            MATCH <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            START: if (IN) next_state = S1; else next_state = START;
            S1:    if (IN) next_state = S1; else next_state = S2;
            S2:    if (IN) next_state = S3; else next_state = START;
            S3:    if (IN) next_state = MATCH; else next_state = S1;
            S4:    if (IN) next_state = MATCH; else next_state = S2;
            MATCH: next_state = MATCH;
            default: next_state = START;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            MATCH: MATCH = 1;
            default: MATCH = 0;
        endcase
    end
endmodule