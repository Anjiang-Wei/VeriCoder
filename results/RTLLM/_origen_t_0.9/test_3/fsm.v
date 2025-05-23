module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [4:0] state;

always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        state <= 5'b00000;
        MATCH <= 1'b0;
    end
    else begin
        case(state)
            5'b00000: begin
                if(IN == 1'b1) state <= 5'b00001;
                else state <= 5'b00000;
            end
            5'b00001: begin
                if(IN == 1'b0) state <= 5'b00010;
                else state <= 5'b00001;
            end
            5'b00010: begin
                if(IN == 1'b0) state <= 5'b00011;
                else state <= 5'b00001;
            end
            5'b00011: begin
                if(IN == 1'b1) state <= 5'b00100;
                else state <= 5'b00000;
            end
            5'b00100: begin
                if(IN == 1'b1) begin
                    state <= 5'b00000;
                    MATCH <= 1'b1;
                end
                else state <= 5'b00010;
            end
            default: begin
                state <= 5'b00000;
                MATCH <= 1'b0;
            end
        endcase
    end
end
endmodule