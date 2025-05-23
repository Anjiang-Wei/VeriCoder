module asyn_fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input       [WIDTH-1:0] wdata,

    output wire             wfull,
    output wire             rempty,
    output wire [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);
reg [ADDR_WIDTH - 1:0] waddr_bin, raddr_bin;
reg [ADDR_WIDTH - 1:0] wptr, rptr;
reg [ADDR_WIDTH - 1:0] wptr_buff, rptr_buff;

wire [WIDTH-1:0] ram_rdata;
wire ram_wen;
wire ram_ren;

// Dual-Port RAM Instance
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(ram_wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ram_ren),
    .raddr(raddr_bin),
    .rdata(ram_rdata)
);

// Write Process
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc && !wfull) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= wptr + 1;
    end
end

// Read Process
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc && !rempty) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= rptr + 1;
    end
end

// Gray Code Conversion
wire [ADDR_WIDTH-1:0] wptr_gray;
wire [ADDR_WIDTH-1:0] rptr_gray;

assign wptr_gray = wptr ^ (wptr >> 1);
assign rptr_gray = rptr ^ (rptr >> 1);

reg [ADDR_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] wptr_syn;

// Pointer Synchronizers
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_syn <= 0;
    end else begin
        wptr_syn <= wptr_gray;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_syn <= 0;
    end else begin
        rptr_syn <= rptr_gray;
    end
end

// Full & Empty Logic
assign wfull = (wptr_syn[ADDR_WIDTH-1] != rptr_syn[ADDR_WIDTH-1]) && (wptr_syn[ADDR_WIDTH-2:0] == rptr_syn[ADDR_WIDTH-2:0]);
assign rempty = (rptr_syn == wptr_syn);

// RAM Control Signals
assign ram_wen = winc && !wfull;
assign ram_ren = rinc && !rempty;
assign rdata = ram_rdata;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input       [$clog2(DEPTH)-1:0] waddr,
    input       [WIDTH-1:0] wdata,
    input                   rclk,
    input                   renc,
    input       [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    
reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Write operation for dual-port RAM
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation for dual-port RAM
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule