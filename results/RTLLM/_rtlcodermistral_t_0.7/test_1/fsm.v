```verilog
    parameter [4:0] S0 = 5'b00001, S1 = 5'b00010, S2 = 5'b00011, S3 = 5'b00100, S4 = 5'b00101, S5 = 5'b00110, S6 = 5'b00111, S7 = 5'b01000, S8 = 5'b01001, S9 = 5'b01010, S10 = 5'b01011, S11 = 5'b01100, S12 = 5'b01101, S13 = 5'b01110, S14 = 5'b01111, S15 = 5'b10000, S16 = 5'b10001, S17 = 5'b10010, S18 = 5'b10011, S19 = 5'b10100, S20 = 5'b10101, S21 = 5'b10110, S22 = 5'b10111, S23 = 5'b11000, S24 = 5'b11001, S25 = 5'b11010, S26 = 5'b11011, S27 = 5'b11100, S28 = 5'b11101, S29 = 5'b11110, S30 = 5'b11111;
    reg [4:0] state, next_state;
    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 0;
        end
        else begin
            state <= next_state;
            MATCH <= (state == S18);
        end
    end
    
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1) ? S1 : S0;
            S1: next_state = (IN == 0) ? S2 : S0;
            S2: next_state = (IN == 0) ? S3 : S0;
            S3: next_state = (IN == 1) ? S4 : S0;
            S4: next_state = (IN == 1) ? S5 : S0;
            S5: next_state = (IN == 1) ? S6 : S0;
            S6: next_state = (IN == 0) ? S7 : S0;
            S7: next_state = (IN == 0) ? S8 : S0;
            S8: next_state = (IN == 1) ? S9 : S0;
            S9: next_state = (IN == 1) ? S10 : S0;
            S10: next_state = (IN == 0) ? S11 : S0;
            S11: next_state = (IN == 0) ? S12 : S0;
            S12: next_state = (IN == 1) ? S13 : S0;
            S13: next_state = (IN == 1) ? S14 : S0;
            S14: next_state = (IN == 1) ? S15 : S0;
            S15: next_state = (IN == 0) ? S16 : S0;
            S16: next_state = (IN == 0) ? S17 : S0;
            S17: next_state = (IN == 1) ? S18 : S0;
            S18: next_state = (IN == 1) ? S19 : S0;
            S19: next_state = (IN == 0) ? S20 : S0;
            S20: next_state = (IN == 0) ? S21 : S