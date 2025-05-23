module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [1:0]  count;
    reg [7:0]  data_buffer [3:0];
    reg [9:0]  accu_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            valid_out <= 1'b0;
            accu_data <= 10'b0;
            data_buffer[0] <= 8'b0;
            data_buffer[1] <= 8'b0;
            data_buffer[2] <= 8'b0;
            data_buffer[3] <= 8'b0;
        end else begin
            if (valid_in) begin
                data_buffer[count] <= data_in;
                count <= count + 1'b1;
            end
            if (count == 4) begin
                accu_data <= data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];
                valid_out <= 1'b1;
                count <= 2'b00;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
        end else begin
            if (valid_out) begin
                data_out <= accu_data;
            end
        end
    end

endmodule