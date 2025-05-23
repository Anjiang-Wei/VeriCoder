module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [9:0] accumulator;  // 10-bit accumulator to store the sum
    reg [2:0] count;        // 3-bit counter to count the number of valid inputs

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            accumulator <= 10'b0;
            count <= 3'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            if (valid_in) begin
                // Accumulate input data if valid input is received
                accumulator <= accumulator + data_in;
                count <= count + 1;

                // Check if we have received 4 valid data inputs
                if (count == 3'd3) begin
                    // Set valid_out to 1 and output the accumulated sum
                    valid_out <= 1'b1;
                    data_out <= accumulator + data_in; // add last data_in
                    // Reset accumulator and count for the next round
                    accumulator <= 10'b0;
                    count <= 3'b0;
                end else begin
                    valid_out <= 1'b0; // valid_out remains 0 until we accumulate 4 inputs
                end
            end else begin
                valid_out <= 1'b0; // valid_out will not be true if valid_in is not asserted
            end
        end
    end

endmodule