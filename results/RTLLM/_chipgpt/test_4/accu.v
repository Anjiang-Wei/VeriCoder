module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

reg[3:0] count;
parameter MIN = 4'd0,
        ONE  = 4'd1,
        TWO  = 4'd2,
        THREE= 4'd3;
always @(posedge clk) begin
    if (rst_n) count <= MIN;
    else if (valid_in && !count[ONE]) count <= ONE;
    else if (valid_in && !count[TWO]) count <= TWO;
    else if (valid_in && !count[THREE]) count <= THREE;
    else count <= MIN;
end

always @* begin
    valid_out = 0;
    data_out = 0;
    case(count)
        4'd0:
            data_out = data_in[7:0];
        ONE:
            if (valid_in)
                data_out = data_in[0];
            valid_out = 1;
        TWO:
            if (valid_in && !valid_out)
                data_out = data_in[8:1]; //add last bit to get total sum of 4 data points.
            valid_out = 1;
        THREE:
            if (valid_in && !valid_out) begin
                data_out = data_in[9:2]; //add two bits to get the sum of 4 data points.
                valid_out = 1;
            end
    endcase
end

endmodule