module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// Internal registers to keep track of the input data and count
reg [7:0] data_buffer[0:3]; // Buffer for 4 input data
reg [1:0] count;             // Count of received valid inputs

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 0;
        data_out <= 10'b0;
        count <= 2'b0;
    end else begin
        if (valid_in) begin
            // Store the incoming data in the buffer
            data_buffer[count] <= data_in;
            count <= count + 1'b1;

            // When 4 items have been received
            if (count == 2'd3) begin
                // Calculate the sum of the 4 data values
                data_out <= data_buffer[0] + data_buffer[1] + 
                            data_buffer[2] + data_buffer[3];
                valid_out <= 1'b1;  // Set valid_out for one cycle
                count <= 2'b0;      // Reset count for the next batch
            end else begin
                valid_out <= 1'b0;  // Keep valid_out low until 4 data received
            end
        end else begin
            valid_out <= 1'b0;      // Keep valid_out low if valid_in is not high
        end
    end
end

endmodule