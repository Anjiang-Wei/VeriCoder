```verilog
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;
    
    reg [1:0] state, next_state;
    
    always @(posedge CLK, posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 0;
        end
        else begin
            state <= next_state;
            case (state)
                S0: begin
                    MATCH <= 0;
                    if (IN == 1'b1) begin
                        next_state <= S1;
                    end
                    else begin
                        next_state <= S0;
                    end
                end
                S1: begin
                    MATCH <= 0;
                    if (IN == 1'b0) begin
                        next_state <= S2;
                    end
                    else begin
                        next_state <= S1;
                    end
                end
                S2: begin
                    MATCH <= 0;
                    if (IN == 1'b1) begin
                        next_state <= S3;
                    end
                    else begin
                        next_state <= S2;
                    end
                end
                S3: begin
                    MATCH <= 1;
                    if (IN == 1'b0) begin
                        next_state <= S2;
                    end
                    else begin
                        next_state <= S3;
                    end
                end
                default: begin
                    MATCH <= 0;
                    next_state <= S0;
                end
            endcase
        end
    end
endmodule