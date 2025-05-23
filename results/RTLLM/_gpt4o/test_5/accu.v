module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out   , 
    output  reg [9:0]   data_out
);
    // Internal signals
    reg [9:0]    accumulator;  // Accumulator to sum the 4 input data
    reg [1:0]    data_count;   // Counter to keep track of received data (range up to 4)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all outputs and internal registers
            valid_out   <= 1'b0;
            data_out    <= 10'b0;
            accumulator <= 10'b0;
            data_count  <= 2'b0;
        end else begin
            if (valid_in) begin
                // Accumulate input data and increment data_count
                accumulator <= accumulator + data_in;
                data_count <= data_count + 1'b1;

                if (data_count == 2'b11) begin
                    // Once 4 valid inputs are received, output the accumulated result
                    data_out  <= accumulator + data_in; // Include the 4th input in the result
                    valid_out <= 1'b1;
                    
                    // Reset accumulator and counter
                    accumulator <= 10'b0;
                    data_count  <= 2'b0;
                end else begin
                    // Assert valid_out low when we haven't accumulated 4 inputs yet
                    valid_out <= 1'b0;
                end
            end else begin
                // When valid_in is low, maintain state
                valid_out   <= 1'b0;
            end
        end
    end

endmodule