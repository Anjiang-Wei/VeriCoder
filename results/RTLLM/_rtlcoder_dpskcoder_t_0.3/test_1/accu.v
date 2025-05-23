module top_module(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

reg [7:0] data_reg [3:0];
reg [1:0] count;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        if (valid_in) begin
            data_reg[count] <= data_in;
            count <= count + 1;
            if (count == 4) begin
                data_out <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out <= 1;
                count <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule