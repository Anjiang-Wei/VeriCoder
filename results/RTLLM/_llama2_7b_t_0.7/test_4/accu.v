module accu(
    input               clk         ,
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// Define the variables to store the accumulated values
reg [10:0] accumulator = 0;
reg [1:0] cycle = 0;

// Define the behavior of the module
always @(posedge clk or negedge rst_n) begin
    // Check if valid_in is high and there are enough input data
    if (valid_in & ($size(data_in) == 4)) begin
        // Accumulate the input data
        accumulator = accumulator + data_in;
        
        // Set valid_out to 1 for 4 cycles
        valid_out <= 1;
        
        // Reset cycle counter
        cycle <= 0;
    end
    // Otherwise, set valid_out to 0
    else begin
        valid_out <= 0;
    end
end

// Output the accumulated value
data_out <= accumulator;