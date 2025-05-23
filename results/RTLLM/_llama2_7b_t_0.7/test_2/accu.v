module accu(
    input               clk         ,
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// Initialize the accumulator to zero
always @* begin
    data_out <= 0;
end

// Process the input data and update the accumulator
always @(posedge clk or posedge rst_n) begin
    if (valid_in) begin
        data_out <= data_out + data_in;
    end
end

// Check for a valid output after 4 inputs have been received
always @* begin
    if (valid_in & (data_out [9] == 0x100)) begin
        valid_out <= 1;
        data_out <= {data_out[8], 0}; // Reset the accumulator
    end
end