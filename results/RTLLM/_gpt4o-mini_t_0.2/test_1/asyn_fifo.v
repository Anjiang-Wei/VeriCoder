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
    
// Dual-port RAM instance
wire [WIDTH-1:0] rdata_ram;
wire [ADDR_WIDTH-1:0] waddr, raddr;
wire wenc, renc;

// Instantiate the dual-port RAM
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata_ram)
);

// Write Pointer & Read Pointer
reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
reg [ADDR_WIDTH:0] wptr, rptr;
reg [ADDR_WIDTH:0] wptr_buff, rptr_buff;

// Generate Gray Code
wire [ADDR_WIDTH:0] wptr_gray, rptr_gray;

assign waddr = wptr[ADDR_WIDTH-1:0];
assign raddr = rptr[ADDR_WIDTH-1:0];

// Gray code conversion for write pointer
assign wptr_gray = wptr ^ (wptr >> 1);
// Gray code conversion for read pointer
assign rptr_gray = rptr ^ (rptr >> 1);

// Write Pointer logic
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc && !wfull) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= wptr + 1;
    end
end

// Read Pointer logic
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc && !rempty) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= rptr + 1;
    end
end

// Pointer Synchronization
always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// FIFO Full and Empty Flag Logic
assign wenc = winc && !wfull;
assign renc = rinc && !rempty;

assign wfull = (wptr_gray[ADDR_WIDTH:1] == {~rptr_gray[ADDR_WIDTH], rptr_gray[ADDR_WIDTH-1:0]});
assign rempty = (wptr_gray == rptr_gray);

// Read Data Output
assign rdata = (rempty) ? {WIDTH{1'b0}} : rdata_ram;

endmodule