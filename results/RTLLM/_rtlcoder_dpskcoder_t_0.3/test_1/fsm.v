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
                if (IN) begin
                    state <= 3'b001;
                    MATCH <= 1'b0;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b001: begin
                if (IN) begin
                    state <= 3'b010;
                    MATCH <= 1'b0;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b010: begin
                if (IN) begin
                    state <= 3'b011;
                    MATCH <= 1'b0;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b011: begin
                if (IN) begin
                    state <= 3'b100;
                    MATCH <= 1'b0;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b100: begin
                if (IN) begin
                    state <= 3'b101;
                    MATCH <= 1'b1;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b101: begin
                if (IN) begin
                    state <= 3'b110;
                    MATCH <= 1'b0;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b110: begin
                if (IN) begin
                    state <= 3'b111;
                    MATCH <= 1'b0;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b111: begin
                if (IN) begin
                    state <= 3'b100;
                    MATCH <= 1'b1;
                end
                else begin
                    state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
        endcase
    end
end

endmodule