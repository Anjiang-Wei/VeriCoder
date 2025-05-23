module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] state;
parameter IDLE = 3'b000, STATE0 = 3'b001, STATE1 = 3'b010, STATE2 = 3'b011, STATE3 = 3'b100;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= STATE0;
                end
                else begin
                    state <= IDLE;
                end
            end
            STATE0: begin
                if (data_in == 1'b0) begin
                    state <= STATE1;
                end
                else begin
                    state <= IDLE;
                end
            end
            STATE1: begin
                if (data_in == 1'b1) begin
                    state <= STATE2;
                end
                else begin
                    state <= STATE1;
                end
            end
            STATE2: begin
                if (data_in == 1'b0) begin
                    state <= STATE3;
                    data_out <= 1;
                end
                else begin
                    state <= STATE2;
                end
            end
            STATE3: begin
                if (data_in == 1'b1) begin
                    state <= IDLE;
                    data_out <= 0;
                end
                else begin
                    state <= STATE3;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule