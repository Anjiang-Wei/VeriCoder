module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [2:0] count;
    reg [9:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'd0;
            sum <= 10'd0;
            valid_out <= 1'b0;
            data_out <= 10'd0;
        end
        else if (valid_in) begin
            if (count < 3'd4) begin
                sum <= sum + data_in;
                count <= count + 1'b1;
            end
            
            if (count == 3'd3) begin
                valid_out <= 1'b1;
                data_out <= sum + data_in;
                sum <= data_in;
                count <= 3'd1;
            end
            else if (count == 3'd4) begin
                valid_out <= 1'b0;
                sum <= 10'd0;
                count <= 3'd0;
            end
        end
        else begin
            valid_out <= 1'b0;
        end
    end

endmodule