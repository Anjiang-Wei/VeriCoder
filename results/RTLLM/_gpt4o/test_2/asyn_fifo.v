module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input      [WIDTH-1:0]  wdata,

    output wire             wfull,
    output wire             rempty,
    output wire [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// Binary write and read pointers
reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;

// Gray-coded write and read pointers
reg [ADDR_WIDTH:0] wptr_gray, rptr_gray;

// Synchronized read pointer and write pointer
reg [ADDR_WIDTH:0] rptr_gray_sync1, rptr_gray_sync2;
reg [ADDR_WIDTH:0] wptr_gray_sync1, wptr_gray_sync2;

// Write and read addresses decoded from Gray pointers (lower ADDR_WIDTH bits)
wire [ADDR_WIDTH-1:0] waddr = wptr_gray[ADDR_WIDTH-1:0];
wire [ADDR_WIDTH-1:0] raddr = rptr_gray[ADDR_WIDTH-1:0];

// Full and empty condition
assign wfull = (wptr_gray == {~rptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rptr_gray_sync2[ADDR_WIDTH-2:0]});
assign rempty = (rptr_gray == wptr_gray_sync2);

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
    end else if (winc && !wfull) begin
        wptr_bin <= wptr_bin + 1;
        wptr_gray <= (wptr_bin >> 1) ^ wptr_bin;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
    end else if (rinc && !rempty) begin
        rptr_bin <= rptr_bin + 1;
        rptr_gray <= (rptr_bin >> 1) ^ rptr_bin;
    end
end

// Synchronizing read pointer to write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_gray_sync1 <= 0;
        rptr_gray_sync2 <= 0;
    end else begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end
end

// Synchronizing write pointer to read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_gray_sync1 <= 0;
        wptr_gray_sync2 <= 0;
    end else begin
        wptr_gray_sync1 <= wptr_gray;
        wptr_gray_sync2 <= wptr_gray_sync1;
    end
end

// Instantiate the dual-port RAM
dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) u_dual_port_RAM (
    .wclk(wclk),
    .wenc(winc && !wfull),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc && !rempty),
    .raddr(raddr),
    .rdata(rdata)
);

endmodule

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
    input                   wclk,
    input                   wenc,
    input  [ADDR_WIDTH-1:0] waddr,
    input  [WIDTH-1:0]      wdata,

    input                   rclk,
    input                   renc,
    input  [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);
reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Write logic
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read logic
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end else begin
        rdata <= {WIDTH{1'b0}}; // Default value for unused reads
    end
end

endmodule