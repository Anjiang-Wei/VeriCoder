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
        count <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        if (valid_in) begin
            data_reg[count] <= data_in;
            count <= count + 1;
            if (count == 4) begin
                data_out <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end
end

endmodule