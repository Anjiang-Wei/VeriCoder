eerst initialiseren we state met de initial state
mathop initial state carries the information that a new pulse is possible
beginnen we meteen met de detectie van een new pulse, dat is als data_in 0 -> 1.
als data_out 1 is, komen we al op de laatste cycle van de huidige pulse.
 als data_out 0 is, komen we op de eerste cycle van de huidige pulse.

Dat is de reden dat we data_out gebruikend data_out in de detectie.als data_out 1 is, komen we al op de laatste cycle van de huidige pulse.
``` verilog
    reg [1:0] state;
beginnen we meteen met de detectie van een new pulse, dat is als data_in 0 -> 1.
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 2'b00;
            data_out <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    if (data_in == 1'b1) begin
                        state <= 2'b01;
                        data_out <= 1'b0;
                    end else begin
                        state <= 2'b00;
                        data_out <= 1'b0;
                    end
                end
                2'b01: begin
                    if (data_in == 1'b0) begin
                        state <= 2'b10;
                        data_out <= 1'b1;
                    end else begin
                        state <= 2'b01;
                        data_out <= 1'b0;
                    end
                end
                2'b10: begin
                    if (data_in == 1'b1) begin
                        state <= 2'b10;
                        data_out <= 1'b1;
                    end else begin
                        state <= 2'b01;
                        data_out <= 1'b0;
                    end
                end . endcase
            end
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 2'b00;
            data_out <= 1'b0;
        end else begin
            data_out <= (state == 2'b10);
        end
    end
endmodule