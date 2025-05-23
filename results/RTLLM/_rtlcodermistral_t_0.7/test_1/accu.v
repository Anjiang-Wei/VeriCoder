```verilog
    reg [7:0] data_reg [3:0];
    reg [3:0] count;
    
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            valid_out <= 0;
            data_out <= 0;
            count <= 0;
        end
        else begin
            if (valid_in) begin
                data_reg[count] <= data_in;
                count <= count + 1;
                if (count == 4) begin
                    valid_out <= 1;
                    data_out <= {data_reg[0], data_reg[1], data_reg[2], data_reg[3], 1'b0};
                    count <= 0;
                end
            end
            else begin
                valid_out <= 0;
            end
        end
    end
endmodule