module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;

    reg [4:0] state, next_state;

    // State encoding
    parameter S0 = 5'b00000;
    parameter S1 = 5'b00001;
    parameter S2 = 5'b00010;
    parameter S3 = 5'b00011;
    parameter S4 = 5'b00100;
    parameter SMATCH = 5'b01000;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= (state == SMATCH);
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S2 : S0;
            S2: next_state = IN ? S3 : S0;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? SMATCH : S0;
            SMATCH: next_state = S0;
            default: next_state = S0;
        endcase
    end

endmodule