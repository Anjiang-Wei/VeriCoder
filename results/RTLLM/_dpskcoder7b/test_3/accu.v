module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

reg [3:0] counter; // Counter for tracking the number of valid inputs
reg [9:0] sum; // Accumulated sum

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'b0000; // Reset counter
        valid_out <= 1'b0; // Reset valid_out
        sum <= 10'b0000000000; // Reset sum
    end else begin
        if (valid_in && counter < 4) begin
            sum <= sum + data_in; // Accumulate input data
            counter <= counter + 1; // Increment counter
        end

        if (counter == 4) begin
            data_out <= sum; // Output the accumulated sum
            valid_out <= 1'b1; // Set valid_out to 1
        end else begin
            valid_out <= 1'b0; // Reset valid_out
        end
    end
end

endmodule