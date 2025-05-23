module fsm(IN, MATCH, CLK, RST);
    input IN, CLK, RST;
    output reg MATCH;

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t current_state, next_state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        bestMATCH = 1'b0; // default value for MATCH
        case (current_state)
            S0: begin
                if (IN) next_state = S1; // If IN=1, go to S1
                else next_state = S0;     // If IN=0, stay in S0
            end
            S1: begin
                if (IN) next_state = S1; // Stay in S1 with IN=1
                else next_state = S2;     // If IN=0, go to S2
            end
            S2: begin
                if (IN) next_state = S3; // If IN=1, go to S3
                else next_state = S0;     // If IN=0, go back to S0
            end
            S3: begin
                if (IN) next_state = S1; // If IN=1, go back to S1 (loop)
                else next_state = S4;     // If IN=0, go to S4
            end
            S4: begin
                MATCH = 1'b1;             // MATCH is asserted
                if (IN) next_state = S1; // If IN=1, go back to S1
                else next_state = S0;     // If IN=0, go back to S0
            end
            default: begin
                next_state = S0;          // Default state
            end
        endcase
    end
endmodule