module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;
    reg [4:0] state, next_state;

    // State encoding: 5-bit state machine with 6 states
    parameter S0 = 5'b00000; // Initial state
    parameter S1 = 5'b00001; // After receiving 1
    parameter S2 = 5'b00010; // After receiving 10
    parameter S3 = 5'b00011; // After receiving 100
    parameter S4 = 5'b00100; // After receiving 1001
    parameter S5 = 5'b00101; // After receiving 10011 (MATCH state)

    // State transition logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= (state == S5);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S0;
            S2: next_state = (IN == 1'b0) ? S2 : S3;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S5 : S0;
            S5: next_state = (IN == 1'b0) ? S0 : S5;
            default: next_state = S0;
        endcase
    end

endmodule