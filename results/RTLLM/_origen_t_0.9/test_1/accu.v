module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

reg [1:0] count;
reg [9:0] sum;
reg [3:0] valid_in_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 2'b00;
        sum <= 10'b0;
        valid_in_reg <= 4'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        valid_in_reg <= {valid_in_reg[2:0], valid_in};
        
        if (valid_in_reg[3] && !valid_in_reg[2]) begin
            sum <= 10'b0;
            count <= 2'b00;
            valid_out <= 1'b0;
        end else if (valid_in_reg[3] && valid_in_reg[2]) begin
            if (count < 2'b11) begin
                sum <= sum + data_in;
                count <= count + 1'b1;
            end else begin
                data_out <= sum + data_in;
                valid_out <= 1'b1;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule