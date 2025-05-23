module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out   ,
    output  reg [9:0]   data_out
);

// Internal registers
reg [9:0] sum;      // Register to accumulate the sum (10 bits to support overflow from 4 x 8 bit additions)
reg [1:0] count;    // 2-bit counter to keep track of the number of valid inputs received

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset everything
        sum       <= 10'd0;
        count     <= 2'd0;
        data_out  <= 10'd0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            // Accumulate input data and increment counter
            sum <= sum + data_in;
            count <= count + 1;

            // Check if 4 valid inputs have been accumulated
            if (count == 2'd3) begin
                data_out <= sum + data_in; // Output accumulated sum
                valid_out <= 1'b1;         // Set valid_out for 1 cycle
                sum <= 10'd0;              // Reset sum for the next accumulation
                count <= 2'd0;             // Reset counter
            end else begin
                valid_out <= 1'b0;         // valid_out is 0 for intermediate cycles
            end
        end else begin
            // If valid_in is not asserted, hold output steady and keep valid_out = 0
            valid_out <= 1'b0;
        end
    end
end

endmodule