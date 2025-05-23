```verilog
    parameter DATA_WIDTH = 8;
    parameter DATA_COUNT = 4;
    parameter DATA_OUT_WIDTH = DATA_WIDTH + 2;
    
    reg [DATA_WIDTH-1:0] data_reg [0:DATA_COUNT-1];
    reg [DATA_OUT_WIDTH-1:0] data_out_reg;
    reg [DATA_COUNT-1:0] valid_count;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_reg <= 0;
            valid_count <= 0;
            data_out_reg <= 0;
            valid_out <= 0;
        end
        else begin
            if (valid_in) begin
                data_reg[valid_count] <= data_in;
                valid_count <= valid_count + 1;
                if (valid_count == DATA_COUNT) begin
                    data_out_reg <= {DATA_OUT_WIDTH{1'b0}};
                    for (valid_count = 0; valid_count < DATA_COUNT; valid_count = valid_count + 1) begin
                        data_out_reg <= data_out_reg + data_reg[valid_count];
                    end
                    valid_out <= 1;
                end
            end
            else begin
                valid_out <= 0;
            end
        end
    end
    
    assign data_out = data_out_reg;
    
endmodule