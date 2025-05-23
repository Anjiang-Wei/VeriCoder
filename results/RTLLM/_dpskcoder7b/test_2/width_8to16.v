reg [7:0] data_lock;
    reg flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            flag <= 1'b0;
        end
        else if (valid_in && !flag) begin
            data_lock <= data_in;
            flag <= 1'b1;
        end
        else if (valid_in && flag) begin
            data_out <= {data_lock, data_in};
            valid_out <= 1'b1;
            flag <= 1'b0;
        end
    end
endmodule