module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [7:0] data_reg [0:3];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                data_reg[i] <= 8'b0;
            end
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            if (valid_in) begin
                data_reg[0] <= data_in;
                for (i = 1; i < 4; i = i + 1) begin
                    data_reg[i] <= data_reg[i-1];
                end
                if (i == 3) begin
                    valid_out <= 1'b1;
                    data_out <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                end else begin
                    valid_out <= 1'b0;
                end
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule