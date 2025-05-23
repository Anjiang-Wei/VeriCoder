module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// Define the input and output signals
localparam INPUT_WIDTH = 8; // 8-bit input data width
localparam OUTPUT_WIDTH = 10; // 10-bit output data width

// Define the signal for accumulating data
reg [INPUT_WIDTH-1:0] accumulator = 0;

// Define the signal for indicating when data is valid
reg [1:0] valid = 0; // Valid input signal

// Define the clock signal
wire clk;

// Instantiate the clock module
clock_module clock (
    .clk(clk),
    .rst_n(rst_n)
);

// Assign the clock signal to the accumulator and valid signals
accumulator <= accumulator + valid;
valid <= valid + 1;

// Combine the input data with the accumulator
wire [OUTPUT_WIDTH-1:0] output = accumulator[INPUT_WIDTH-1:0];

// Set the output signal to valid when there are four inputs
when (valid === 4)
    valid_out <= 1;