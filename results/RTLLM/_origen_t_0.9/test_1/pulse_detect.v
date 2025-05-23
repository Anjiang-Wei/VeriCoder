module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    reg [2:0] state;
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= S0;
            data_out <= 1'b0;
        end else begin
            case (state)
                S0: begin
                    if (data_in) begin
                        state <= S1;
                        data_out <= 1'b0;
                    end else begin
                        state <= S0;
                        data_out <= 1'b0;
                    end
                end
                S1: begin
                    if (data_in) begin
                        state <= S1;
                        data_out <= 1'b0;
                    end else begin
                        state <= S2;
                        data_out <= 1'b0;
                    end
                end
                S2: begin
                    if (data_in) begin
                        state <= S1;
                        data_out <= 1'b0;
                    end else begin
                        state <= S3;
                        data_out <= 1'b0;
                    end
                end
                S3: begin
                    if (data_in) begin
                        state <= S1;
                        data_out <= 1'b0;
                    end else begin
                        state <= S4;
                        data_out <= 1'b1;
                    end
                end
                S4: begin
                    if (data_in) begin
                        state <= S1;
                        data_out <= 1'b0;
                    end else begin
                        state <= S0;
                        data_out <= 1'b0;
                    end
                end
                default: begin
                    state <= S0;
                    data_out <= 1'b0;
                end
            endcase
        end
    end
endmodule