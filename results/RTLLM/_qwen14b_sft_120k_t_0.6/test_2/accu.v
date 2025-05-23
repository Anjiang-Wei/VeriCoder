module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [7:0] data_accum[3:0];
    reg [9:0] sum;
    reg [1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_accum[0] <= 8'b0;
            data_accum[1] <= 8'b0;
            data_accum[2] <= 8'b0;
            data_accum[3] <= 8'b0;
            sum <= 10'b0;
            count <= 2'b00;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            if (count == 2'b11) begin
                sum <= data_accum[0] + data_accum[1] + data_accum[2] + data_accum[3];
                data_out <= sum;
                valid_out <= 1'b1;
                count <= 2'b00;
            end else begin
                data_accum[count] <= data_in;
                count <= count + 1'b1;
            end
        end
    end

endmodule