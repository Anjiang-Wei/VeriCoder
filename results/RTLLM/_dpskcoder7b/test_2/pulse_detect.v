module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    reg [1:0] state;

    // State machine for pulse detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            data_out <= 1'b0;
        end else begin
            case (state)
                2'b00: if (data_in) state <= 2'b01;
                2'b01: if (!data_in) state <= 2'b10;
                2'b10: if (data_in) begin
                            state <= 2'b00;
                            data_out <= 1'b1;
                        end else begin
                            data_out <= 1'b0;
                        end
                default: state <= 2'b00;
            endcase
        end
    end
endmodule