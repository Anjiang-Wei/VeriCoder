module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Data bit control signals
localparam I = 16; // Shift count register
localparam RST_N = 0; // Reset signal
localparam START = 1; // Start signal

// Input signals
input clk;
input rst_n;
input start;
input [15:0] ain;
input [15:0] bin;

// Output signals
output [31:0] yout;
output done;

// Module definition
module multi_16bit (clk, rst_n, start, ain, bin, yout, done);

// Instantiate the module
mult_16bit mult_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .ain(ain),
    .bin(bin),
    .yout(yout),
    .done(done)
);