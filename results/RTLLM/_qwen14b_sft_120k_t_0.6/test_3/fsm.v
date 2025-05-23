module fsm(IN, MATCH, CLK, RST);
    input IN;
    input CLK;
    input RST;
    output reg MATCH;
    reg [4:0] state, next_state;
    reg [4:0] target_sequence; // Store the target sequence 10011

    // Define the states
    parameter S0 = 5'b00000,
              S1 = 5'b00001,
              S2 = 5'b00010,
              S3 = 5'b00100,
              S4 = 5'b01000,
              S5 = 5'b10000;

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
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S0 : S2;
            S2: next_state = IN ? S0 : S3;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S5 : S0;
            S5: next_state = S0; // Reset to S0 after match
            default: next_state = S0;
        endcase
    end
endmodule