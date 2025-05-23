module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    // Internal signals
    reg [7:0] data_reg [3:0];
    reg [9:0] sum;
    reg [1:0] cnt;

    // Initialize internal registers
    initial begin
        cnt <= 2'b00;
        sum <= 10'b0;
        valid_out <= 1'b0;
    end

    // Synchronous reset and clock process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            sum <= 10'b0;
            valid_out <= 1'b0;
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
        end else begin
            // Accumulate data
            if (valid_in) begin
                data_reg[cnt] <= data_in;
                cnt <= cnt + 1;
                if (cnt == 2'b11) begin
                    // Calculate the sum of the 4 data inputs
                    sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                    valid_out <= 1'b1;
                    cnt <= 2'b00;
                end
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

    // Assign the sum to data_out
    always @* begin
        data_out = sum;
    end
endmodule