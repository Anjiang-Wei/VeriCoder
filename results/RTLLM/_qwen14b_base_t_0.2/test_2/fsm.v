module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;

    // Define states
    typedef enum reg [3:0] {
        S0, S1, S2, S3, S4, S5
    } state_t;

    // State register
    reg [3:0] current_state, next_state;

    // State transition logic
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            current_state <= S0;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: if (IN == 1) next_state = S1; else next_state = S0;
            S1: if (IN == 0) next_state = S2; else next_state = S0;
            S2: if (IN == 0) next_state = S2; else next_state = S3;
            S3: if (IN == 1) next_state = S4; else next_state = S0;
            S4: if (IN == 1) next_state = S5; else next_state = S0;
            S5: next_state = S5;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            S5: MATCH = 1;
            default: MATCH = 0;
        endcase
    end
endmodule