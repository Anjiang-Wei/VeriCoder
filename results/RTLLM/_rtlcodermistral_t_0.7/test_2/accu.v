```verilog
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = $clog2(DATA_WIDTH);
    
    reg [ADDR_WIDTH-1:0] data_reg [3:0];
    reg [ADDR_WIDTH:0] sum_reg;
    reg [ADDR_WIDTH-1:0] cnt_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            valid_out <= 0;
            data_out <= 0;
            cnt_reg <= 0;
            sum_reg <= 0;
            data_reg <= {4{0}};
        end else begin
            if (valid_in) begin
                data_reg[cnt_reg] <= data_in;
                cnt_reg <= cnt_reg + 1;
                if (cnt_reg == 3) begin
                    sum_reg <= {data_reg[0], data_reg[1], data_reg[2], data_reg[3]};
                    valid_out <= 1;
                    data_out <= sum_reg;
                    cnt_reg <= 0;
                end
            end else begin
                valid_out <= 0;
                data_out <= 0;
            end
        end
    end
endmodule