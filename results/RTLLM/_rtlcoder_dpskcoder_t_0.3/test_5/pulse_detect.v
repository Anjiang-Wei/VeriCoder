reg [1:0] state;
parameter IDLE = 2'b00;
parameter PULSE_START = 2'b01;
parameter PULSE_END = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= PULSE_START;
                end
            end
            PULSE_START: begin
                if (~data_in) begin
                    state <= PULSE_END;
                end
            end
            PULSE_END: begin
                if (data_in) begin
                    state <= PULSE_START;
                    data_out <= 1'b1;
                end
                else begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            end
        endcase
    end
end