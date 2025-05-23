reg [2:0] state, next_state;
parameter IDLE = 3'b000, STATE1 = 3'b001, STATE2 = 3'b010, STATE3 = 3'b011, STATE4 = 3'b100, STATE5 = 3'b101, STATE6 = 3'b110, STATE7 = 3'b111;
initial state = IDLE;
always @(posedge CLK) begin
    if(RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        state <= next_state;
        case(state)
            IDLE: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = IDLE;
                    MATCH <= 0;
                end
            end
            STATE1: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = STATE2;
                    MATCH <= 0;
                end
            end
            STATE2: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = STATE3;
                    MATCH <= 0;
                end
            end
            STATE3: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = STATE4;
                    MATCH <= 0;
                end
            end
            STATE4: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = STATE5;
                    MATCH <= 0;
                end
            end
            STATE5: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = STATE6;
                    MATCH <= 0;
                end
            end
            STATE6: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = STATE7;
                    MATCH <= 0;
                end
            end
            STATE7: begin
                if(IN) begin
                    next_state = STATE1;
                    MATCH <= 0;
                end else begin
                    next_state = STATE1;
                    MATCH <= 0;
                end
            end
        endcase
    end
end
endmodule