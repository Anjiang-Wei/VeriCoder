```verilog
    reg [4:0] state;
    parameter S0 = 5'b00000;
    parameter S1 = 5'b00001;
    parameter S2 = 5'b00010;
    parameter S3 = 5'b00011;
    parameter S4 = 5'b00100;
    parameter S5 = 5'b00101;
    
    always @(posedge CLK, posedge RST) begin
        if (RST) begin
            MATCH <= 0;
            state <= S0;
        end else begin
            case (state)
                S0: begin
                    if (IN) begin
                        state <= S1;
                    end else begin
                        state <= S0;
                    end
                end
                S1: begin
                    if (!IN) begin
                        state <= S2;
                    end else begin
                        state <= S1;
                    end
                end
                S2: begin
                    if (!IN) begin
                        state <= S3;
                    end else begin
                        state <= S0;
                    end
                end
                S3: begin
                    if (IN) begin
                        state <= S4;
                    end else begin
                        state <= S0;
                    end
                end
                S4: begin
                    if (IN) begin
                        state <= S5;
                    end else begin
                        state <= S0;
                    end
                end
                S5: begin
                    if (IN) begin
                        state <= S0;
                        MATCH <= 1;
                    end else begin
                        state <= S0;
                        MATCH <= 0;
                    end
                end
            endcase
        end
    end
endmodule