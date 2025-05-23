module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    reg [7:0] data_reg [0:3];
    reg [3:0] count;
    reg [9:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
            count <= 4'd0;
            sum <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            if (valid_in) begin
                case (count)
                    4'd0: data_reg[0] <= data_in;
                    4'd1: data_reg[1] <= data_in;
                    4'd2: data_reg[2] <= data_in;
                    4'd3: begin
                        data_reg[3] <= data_in;
                        sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                        valid_out <= 1'b1;
                        data_out <= sum;
                    end
                    default: count <= 4'd0;
                endcase
                count <= count + 1'b1;
            end else begin
                valid_out <= 1'b0;
                data_out <= 10'b0;
            end
        end
    end

endmodule