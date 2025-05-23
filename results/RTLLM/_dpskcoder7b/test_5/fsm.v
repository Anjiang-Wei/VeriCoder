always @(negedge CLK or posedge RST)
begin
    if(RST)
        MATCH <= 1'b0;
    else begin
        case({prev_in, IN})
            2'b00: state <= 2'b00;
            2'b01: state <= 2'b01;
            2'b10: state <= 2'b10;
            2'b11: state <= 2'b11;
            default: state <= 2'b00;
        endcase

        case(state)
            2'b00: MATCH <= 1'b0;
            2'b01: MATCH <= 1'b0;
            2'b10: MATCH <= 1'b0;
            2'b11: MATCH <= 1'b1;
            default: MATCH <= 1'b0;
        endcase
    end
end
endmodule