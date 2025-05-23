module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    reg [7:0] data_reg [0:3];
    reg [9:0] sum;
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                data_reg[i] <= 8'b0;
            end
            sum <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            if (valid_in) begin
                data_reg[0] <= data_in;
                data_reg[1] <= data_reg[0];
                data_reg[2] <= data_reg[1];
                data_reg[3] <= data_reg[2];
                sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out <= 1'b1;
                data_out <= sum;
            end else begin
                valid_out <= 1'b0;
                data_out <= 10'b0;
            end
        end
    end

endmodule