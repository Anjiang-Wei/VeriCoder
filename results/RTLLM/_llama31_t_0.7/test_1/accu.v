module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    reg   [3:0][7:0]   acc           ;
    reg   [9:0]        sum           ;
    integer            count          ;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            count <= 0;
        else if (valid_in) begin
            count <= count + 1;
            acc[count-1] <= data_in;
            sum <= sum + acc[count-1];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        valid_out <= 0;
        if (count >= 4)
            valid_out <= 1;
    end

    always @(posedge clk or negedge rst_n) begin
        data_out <= 0;
        if (count == 4)
            data_out <= sum;
    end

endmodule