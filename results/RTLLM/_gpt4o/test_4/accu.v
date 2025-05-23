module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out   ,
    output  reg [9:0]   data_out
);

    // Internal signals
    reg [9:0] sum;              // Accumulator for the sum of 4 values
    reg [1:0] count;            // Count to track the number of inputs (0 to 3)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all outputs and internal registers
            sum <= 10'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                // Add valid incoming data to the sum
                sum <= sum + data_in;
                count <= count + 2'd1;
                
                // Check if 4 values have been received
                if (count == 2'd3) begin
                    // Assign accumulated sum to the output and assert valid_out
                    data_out <= sum + data_in;  // Include the current value in the sum
                    valid_out <= 1'b1;
                    
                    // Clear sum and reset count
                    sum <= 10'd0;
                    count <= 2'd0;
                end else begin
                    // Less than 4 inputs, valid_out remains de-asserted
                    valid_out <= 1'b0;
                end
            end else begin
                // No valid input, maintain the current state
                valid_out <= 1'b0;
            end
        end
    end

endmodule