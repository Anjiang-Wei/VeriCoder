reg [1:0] state;
    parameter IDLE = 2'b00, PULSE1 = 2'b01, PULSE2 = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    if(data_in)
                        state <= PULSE1;
                end
                PULSE1: begin
                    if(!data_in)
                        state <= PULSE2;
                    else 
                        state <= IDLE;
                end
                PULSE2: begin
                    if(data_in)
                        state <= IDLE;
                    else 
                        state <= PULSE1;
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else begin
            case(state)
                PULSE2: begin
                    data_out <= 1'b1;
                end
                default: begin
                    data_out <= 1'b0;
                end
            endcase
        end
    end
endmodule