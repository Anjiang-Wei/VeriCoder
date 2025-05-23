reg [3:0] counter;
reg [7:0] data_reg [3:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 4'b0;
        data_out <= 10'b0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            data_reg[counter] <= data_in;
            counter <= counter + 1'b1;
            if (counter == 4'b1111) begin
                data_out <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out <= 1'b1;
            end
        end else if (valid_out) begin
            valid_out <= 1'b0;
        end
    end
end
endmodule