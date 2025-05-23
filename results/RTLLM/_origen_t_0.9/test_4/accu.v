module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [7:0] accu_data [3:0];
    reg [1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            if (valid_in) begin
                accu_data[count] <= data_in;
                count <= count + 1'b1;

                if (count == 2'b11) begin
                    data_out <= {2'b00, accu_data[0]} + {2'b00, accu_data[1]} + {2'b00, accu_data[2]} + {2'b00, accu_data[3]};
                    valid_out <= 1'b1;
                    count <= 2'b00;
                end
                else begin
                    valid_out <= 1'b0;
                end
            end
            else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule