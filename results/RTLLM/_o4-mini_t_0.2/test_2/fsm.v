module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

    // state encoding
    localparam [2:0]
        S0 = 3'd0,   // no bits matched
        S1 = 3'd1,   // matched "1"
        S2 = 3'd2,   // matched "10"
        S3 = 3'd3,   // matched "100"
        S4 = 3'd4;   // matched "1001"

    reg [2:0] state, next_state;
    reg       next_match;

    // combinational next‐state and Mealy output logic
    always @(*) begin
        // defaults
        next_state = S0;
        next_match = 1'b0;

        case (state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (IN)
                    next_state = S1;  // "1","1" -> stay in S1
                else
                    next_state = S2;  // "1","0" -> S2
            end

            S2: begin
                if (IN)
                    next_state = S1;  // "10","1" -> overlap as S1
                else
                    next_state = S3;  // "10","0" -> S3
            end

            S3: begin
                if (IN)
                    next_state = S4;  // "100","1" -> S4
                else
                    next_state = S0;  // "100","0" -> back to S0
            end

            S4: begin
                if (IN) begin
                    // "1001","1" => full match
                    next_match = 1'b1;
                    next_state = S1;  // suffix "1" overlaps
                end else begin
                    // "1001","0" -> suffix "10"
                    next_state = S2;
                end
            end

            default: begin
                next_state = S0;
                next_match = 1'b0;
            end
        endcase
    end

    // sequential state register and output register
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= next_match;
        end
    end

endmodule