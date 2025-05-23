```verilog
    parameter IDLE = 2'b00;
    parameter STATE1 = 2'b01;
    parameter STATE2 = 2'b10;
    parameter STATE3 = 2'b11;
    
    reg [1:0] state;
    
    always @(posedge CLK, posedge RST) begin
        if (RST) begin
            state <= IDLE;
            MATCH <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (IN == 1) begin
                        state <= STATE1;
                        MATCH <= 0;
                    end
                end
                STATE1: begin
                    if (IN == 0) begin
                        state <= STATE2;
                        MATCH <= 0;
                    end
                end
                STATE2: begin
                    if (IN == 1) begin
                        state <= STATE3;
                        MATCH <= 1;
                    end
                    else begin
                        state <= STATE1;
                        MATCH <= 0;
                    end
                end
                STATE3: begin
                    if (IN == 0) begin
                        state <= STATE2;
                        MATCH <= 0;
                    end
                end
            endcase
        end
    end
endmodule