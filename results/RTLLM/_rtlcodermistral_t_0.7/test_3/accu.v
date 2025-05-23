```verilog
    reg [9:0] sum;
    reg [1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum <= 0;
            count <= 0;
            valid_out <= 0;
        end else begin
            if (valid_in) begin
                sum <= sum + data_in;
                count <= count + 1;
                if (count == 4) begin
                    data_out <= sum;
                    valid_out <= 1;
                    count <= 0;
                    sum <= 0;
                end else begin
                    valid_out <= 0;
                end
            end
        end
    end

endmodule