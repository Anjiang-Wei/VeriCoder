module fsm(IN,MATCH,CLK,RST);
    input IN,CLK,RST;
    output reg MATCH;
    
    // State encoding
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100;
    
    reg [2:0] current_state, next_state;
    
    // State transition and output logic
    always @(IN or CLK or RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end
        else if (IN != current_state) begin
            case (current_state)
                S0: current_state <= IN ? S1 : S0;
                S1: current_state <= IN ? S1 : S2;
                S2: current_state <= IN ? S3 : S0;
                S3: current_state <= IN ? S4 : S0;
                S4: begin
                    current_state <= IN ? S1 : S2;
                    MATCH <= IN;
                end
                default: current_state <= S0;
            endcase
        end
    end
endmodule