module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] state;
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= S0;
        data_out <= 1'b0;
    end
    else begin
        case (state)
            S0: begin
                if (data_in) state <= S1;
                else state <= S0;
            end
            S1: begin
                if (data_in) state <= S2;
                else state <= S0;
            end
            S2: begin
                if (data_in) state <= S3;
                else state <= S0;
            end
            S3: begin
                if (data_in) state <= S1;
                else begin
                    state <= S0;
                    data_out <= 1'b1;
                end
            end
            default: state <= S0;
        endcase
    end
end

endmodule