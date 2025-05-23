module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk, // Write clock signal
    input rclk, // Read clock signal
    input wrstn, // Write reset signal
    input rrstn, // Read reset signal
    input winc, // Write increment signal
    input rinc, // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input

    output wire wfull, // Write full signal
    output wire rempty, // Read empty signal
    output wire [WIDTH-1:0] rdata // Read data output
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM module
module dual_port_ram #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  wclk, // Write clock signal
    input rclk, // Read clock signal
    input wrstn, // Write reset signal
    input rrstn, // Read reset signal

    output reg [DEPTH-1:0] ram_mem // RAM memory array
);

// Write and read pointers
reg waddr_bin, raddr_bin; // Binary representations of write and read pointers
wire [ADDR_WIDTH-1:0] wptr, rptr; // Two's complement binary representations of write and read pointers

// Write increment and reset
wire winc, wrstn; // Write increment and reset signals

// Read increment and reset
wire rinc, rrstn; // Read increment and reset signals

// Conversion to Gray code
wire [ADDR_WIDTH-1:0] wptr_gray, rptr_gray; // Gray code representations of write and read pointers

// Full and empty conditions
wire full, empty; // Full and empty flags

// Connect inputs and outputs
assign ram_mem = (wclk & ~wrstn) | (rclk & ~rrstn) & wdata;
assign wfull = (wptr_gray == (rptr_gray ^ ADDR_WIDTH[ADDR_WIDTH-1:0]));
assign rempty = (rptr_gray == rptr);

endmodule // End of asyn_fifo module