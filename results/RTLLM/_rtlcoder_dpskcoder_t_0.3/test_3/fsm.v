module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;
reg [2:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 1'b0;
    end
    else begin
        case (state)
            3'b000: begin
                if (IN == 1'b1) begin
                    state <= 3'b001;
                end
            end
            3'b001: begin
                if (IN == 1'b0) begin
                    state <= 3'b010;
                end
            end
            3'b010: begin
                if (IN == 1'b0) begin
                    state <= 3'b011;
                end
            end
            3'b011: begin
                if (IN == 1'b1) begin
                    state <= 3'b100;
                end
            end
            3'b100: begin
                if (IN == 1'b1) begin
                    state <= 3'b101;
                    MATCH <= 1'b1;
                end
            end
            3'b101: begin
                if (IN == 1'b0) begin
                    state <= 3'b000;
                end
            end
        endcase
    end
end

endmodule