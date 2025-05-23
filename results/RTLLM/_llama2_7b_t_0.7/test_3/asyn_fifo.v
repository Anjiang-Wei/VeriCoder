module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire wclk,      // Write clock signal
    input wire rclk,        // Read clock signal
    input wire wrstn,       // Write reset signal
    input wire rrstn,        // Read reset signal
    input wire winc,         // Write increment signal
    input wire rinc,          // Read increment signal
    input [WIDTH-1:0] wdata,   // Write data input

    output wire wfull,       // Full signal
    output wire rempty,        // Empty signal
    output reg [WIDTH-1:0] rdata  // Read data output
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM module
module dual_port_ram #(
    parameter WIDTH = WIDTH,
    parameter DEPTH = DEPTH
)(
    input wire wrclk,      // Write clock signal for port 0
    input wire rdclk,       // Read clock signal for port 1
    input wire wren,         // Write enable signal for port 0
    input wire rden,          // Read enable signal for port 1
    input [WIDTH-1:0] wport_0_addr,   // Address input for port 0
    input [WIDTH-1:0] rport_1_addr,      // Address input for port 1
    output reg [DEPTH*WIDTH-1:0] ram_mem // RAM memory matrix
);

// Write and read pointers
localparam WIDTH_BYTES = WIDTH/8;
wire [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn; // Synthesized write and read pointers
reg [WIDTH-1:0] wptr, rptr; // Write and read pointer registers

// Full and empty conditions
assign wfull = (wptr_syn == (1'b0 & ~(rptr_syn[WIDTH-1:0])))? 1 : 0;
assign rempty = (rptr_syn == (1'b0 & ~(wptr_syn[WIDTH-1:0])))? 1 : 0;

// Write data to RAM
always @* begin
    if (winc) begin
        ram_mem[wport_0_addr] <= wdata;
    end
end

// Read data from RAM
always @* begin
    if (rinc) begin
        rdata <= ram_mem[rport_1_addr];
    end
end

// Connect inputs and outputs
assign wen = wren ? 1 : 0;
assign ren = rden ? 1 : 0;
assign wdata = wdata;

// Add buffer registers for pointer synchronization
localparam BUFFER_WIDTH = WIDTH/8;
reg [BUFFER_WIDTH-1:0] wptr_buff, rptr_buff;
always @* begin
    if (wstb) begin
        wptr_buff <= wptr;
    end
end

always @* begin
    if (rstb) begin
        rptr_buff <= rptr;
    end
end

// Synchronize write and read pointers
always @* begin
    if (|wptr_syn) begin
        wptr <= wptr_syn;
    end
end

always @* begin
    if (|rptr_syn) begin
        rptr <= rptr_syn;
    end
end