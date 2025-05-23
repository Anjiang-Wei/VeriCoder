module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out   ,
    output  reg [9:0]   data_out
);

    // Internal registers:
    // - count: tracks how many valid data have been accumulated.
    // - sum  : accumulates the sum of the input values.
    reg [1:0] count;  // 2 bits are enough for counting 0-3
    reg [9:0] sum;    // 10 bits needed for summing four 8-bit numbers

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: clear all registers.
            sum        <= 10'd0;
            count      <= 2'd0;
            data_out   <= 10'd0;
            valid_out  <= 1'b0;
        end else begin
            // Default valid_out to 0. It will be set to 1 only
            // when the fourth valid input has been received.
            valid_out <= 1'b0;
            
            // When valid_in is asserted, accumulate the data
            if (valid_in) begin
                // Check if this is the fourth valid data.
                if (count == 2'd3) begin
                    // Accumulate this (4th) data and generate output.
                    data_out  <= sum + data_in;
                    valid_out <= 1'b1;
                    // Clear sum and count on completion.
                    sum   <= 10'd0;
                    count <= 2'd0;
                end else begin
                    // For the first three data_in, accumulate the data.
                    sum   <= sum + data_in;
                    count <= count + 2'd1;
                end
            end
        end
    end

endmodule