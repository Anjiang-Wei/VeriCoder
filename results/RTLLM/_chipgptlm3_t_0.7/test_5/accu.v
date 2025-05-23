reg [7:0] data_reg [0:3];
    reg [9:0] data_out_reg;
    reg [2:0] count_reg;
    reg valid_out_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            count_reg <= 0;
            valid_out_reg <= 0;
            data_out_reg <= 0;
            data_reg <= 0;
        end else begin
            if(valid_in) begin
                data_reg[count_reg] <= data_in;
                count_reg <= count_reg + 1;
            end
            
            if(count_reg == 4) begin
                data_out_reg <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out_reg <= 1;
            end else begin
                valid_out_reg <= 0;
            end
            
            data_out <= data_out_reg;
            valid_out <= valid_out_reg;
        end
    end
endmodule