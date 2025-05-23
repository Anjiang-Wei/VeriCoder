module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    // Internal signals
    reg [7:0] data_reg [3:0]; // Register to hold the last 4 data_in values
    reg [9:0] sum;            // Register to hold the accumulated sum
    reg [1:0] count;          // Counter to track the number of valid inputs

    // Initialize internal registers
    initial begin
        count <= 2'b00;
        sum <= 10'b0;
        for (integer i = 0; i < 4; i = i + 1) begin
            data_reg[i] <= 8'b0;
        end
    end

    // Synchronous reset and clock process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            sum <= 10'b0;
            for (integer i = 0; i < 4; i = i + 1) begin
                data_reg[i] <= 8'b0;
            end
        end else begin
            // Accumulate data_in if valid_in is high
            if (valid_in) begin
                data_reg[count] <= data_in;
                count <= count + 1;
            end

            // Reset count and sum when 4 valid inputs are received
            if (count == 4) begin
                count <= 2'b00;
                sum <= 10'b0;
            end
        end
    end

    // Calculate the sum of the last 4 data_in values
    always @(posedge clk) begin
        if (count == 4) begin
            sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
        end
    end

    // Output valid_out and data_out
    always @(posedge clk) begin
        if (count == 4) begin
            valid_out <= 1'b1;
            data_out <= sum;
        end else begin
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
    end
endmodule