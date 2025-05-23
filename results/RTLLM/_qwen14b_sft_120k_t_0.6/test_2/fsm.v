module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;

    // State encoding
    localparam [3:0] S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100;

    reg [3:0] current_state, next_state;

    // State transition logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            MATCH <= (current_state == S4) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S2 : S0;
            S2: next_state = (IN) ? S3 : S0;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S4 : S0;
            default: next_state = S0;
        endcase
    end
endmodule