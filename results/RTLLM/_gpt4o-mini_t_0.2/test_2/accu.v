module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// Internal registers
reg [3:0] count; // Counter for the number of valid input data
reg [9:0] sum;   // Accumulator for the sum of the input data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 0;
        data_out <= 0;
        count <= 0;
        sum <= 0;
    end
    else if (valid_in) begin
        // Accumulate data when valid_in is asserted
        if (count < 4) begin
            sum <= sum + data_in; // Accumulate data
            count <= count + 1;   // Increment the valid data count
        end
        
        // When 4 data entries are received
        if (count == 3) begin // When count reaches 3, next will be the fourth
            valid_out <= 1;   // Set valid_out for one cycle
            data_out <= sum + data_in; // Output the accumulated sum
            count <= 0;       // Reset count for the next batch
            sum <= 0;         // Reset sum for the next batch
        end
        else begin
            valid_out <= 0;   // No output valid until we have 4 inputs
        end
    end
    else begin
        valid_out <= 0;       // Set valid_out to 0 when no new valid data is provided
    end
end

endmodule