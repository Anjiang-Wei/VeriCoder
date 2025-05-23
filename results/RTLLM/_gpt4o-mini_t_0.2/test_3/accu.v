module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    
    reg [9:0] accumulation;  // Accumulator for 4 data_in values
    reg [1:0] count;         // Counter to track number of valid inputs received

    // Asynchronous Reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulation <= 10'b0;
            count <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            if (valid_in) begin
                // Accumulate only if valid data is received
                accumulation <= accumulation + data_in;
                count <= count + 1;

                // Check if we have received 4 valid inputs
                if (count == 2'b11) begin
                    valid_out <= 1'b1;                  // Set valid_out to 1
                    data_out <= accumulation;           // Output the accumulated result
                    // Reset accumulator and count for the next batch
                    accumulation <= 10'b0;              
                    count <= 2'b0;
                end else begin
                    valid_out <= 1'b0;                  // valid_out remains 0 if count < 4
                end
            end else begin
                valid_out <= 1'b0;                      // valid_out is 0 while valid_in is not set
            end
        end
    end
    
endmodule