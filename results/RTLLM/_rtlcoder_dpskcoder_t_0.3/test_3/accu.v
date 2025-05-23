module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [7:0] data_in_reg [3:0];
    reg [3:0] data_count;
    reg [9:0] data_sum;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_count <= 0;
            data_sum <= 0;
            valid_out <= 0;
        end else begin
            if (valid_in) begin
                data_in_reg[data_count] <= data_in;
                data_count <= data_count + 1;
                if (data_count == 4) begin
                    data_sum <= data_in_reg[0] + data_in_reg[1] + data_in_reg[2] + data_in_reg[3];
                    valid_out <= 1;
                end else begin
                    valid_out <= 0;
                end
            end
        end
    end

    assign data_out = data_sum;

endmodule