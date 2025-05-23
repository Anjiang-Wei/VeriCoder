reg [3:0][7:0] data_reg;
    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            valid_out <= 0;
            data_out <= 0;
        end else begin
            if (valid_in) begin
                data_reg[count] <= data_in;
                count <= count + 1;
                if (count == 3) begin
                    valid_out <= 1;
                    data_out <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                end
            end
        end
    end
endmodule