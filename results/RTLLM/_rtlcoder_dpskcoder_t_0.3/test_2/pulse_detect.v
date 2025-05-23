reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        case (state)
            2'b00: begin
                if (data_in == 1'b0) begin
                    state <= 2'b00;
                end
                else begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (data_in == 1'b1) begin
                    state <= 2'b10;
                end
                else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin
                if (data_in == 1'b0) begin
                    state <= 2'b11;
                end
                else begin
                    state <= 2'b10;
                end
            end
            2'b11: begin
                if (data_in == 1'b1) begin
                    state <= 2'b00;
                    data_out <= 1'b1;
                end
                else begin
                    state <= 2'b11;
                end
            end
        endcase
    end
end