module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definition: we use a one-bit state register:
    localparam IDLE = 1'b0;
    localparam HIGH = 1'b1;
    
    reg state;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            data_out  <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= 1'b0;
                    // Wait for a rising edge (0 -> 1).
                    if (data_in == 1'b1)
                        state <= HIGH;
                    else
                        state <= IDLE;
                end
                
                HIGH: begin
                    // Stay in HIGH until data_in falls to 0.
                    if (data_in == 1'b0) begin
                        // Falling edge detected: complete pulse.
                        data_out <= 1'b1;
                        state    <= IDLE;
                    end else begin
                        data_out <= 1'b0;
                        state    <= HIGH;
                    end
                end
                
                default: begin
                    state    <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule