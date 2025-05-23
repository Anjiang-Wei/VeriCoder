module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input [WIDTH-1:0] wdata,

    output wire wfull,
    output wire rempty,
    output reg [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual Port RAM (dual_port_RAM) module
module dual_port_ram #(
    parameter WIDTH = WIDTH,
    parameter DEPTH = DEPTH
)(
    input wire wrclk,
    input wire rdclk,
    input wire wren,
    input wire rden,
    input [WIDTH-1:0] waddr,
    input [WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] ram_mem
);

// Initialize RAM module
initial begin
    wren = 0;
    rden = 0;
end

// Write data to RAM
always@(posedge wclk or negedge wrstn) begin
    if (wrstn == 1'b0) begin
        wren <= 0;
        ram_mem <= 0;
    end else begin
        wren <= wenc;
        ram_mem <= wdata;
    end
end

// Read data from RAM
always@(posedge rclk or negedge rrstn) begin
    if (rrstn == 1'b0) begin
        rden <= 0;
        ram_mem <= 0;
    end else begin
        rden <= rden + $time;
        ram_mem <= ram_mem + ($time * DEPTH / WIDTH);
    end
end

// Combine write and read pointers
always@* begin
    wptr_syn <= (~(DEPTH - 1) << ADDR_WIDTH) & rdata;
    rptr_syn <= wdata;
end

// Calculate full and empty signals
always@* begin
    wfull <= (wptr_syn == rptr_syn);
    rempty <= (rptr_syn == 0);
end

endmodule