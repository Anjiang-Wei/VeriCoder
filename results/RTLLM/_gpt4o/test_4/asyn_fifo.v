module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    // Memory declaration
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
    
    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule


module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input  [WIDTH-1:0]      wdata,

    output wire             wfull,
    output wire             rempty,
    output wire [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// Binary and Gray code pointers
reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;
reg [ADDR_WIDTH:0] wptr_gray, rptr_gray;
reg [ADDR_WIDTH:0] rptr_gray_sync1, rptr_gray_sync2;
reg [ADDR_WIDTH:0] wptr_gray_sync1, wptr_gray_sync2;

// Dual-Port RAM instantiation
wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) ram_inst (
    .wclk(wclk),
    .wenc(~wfull & winc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(~rempty & rinc),
    .raddr(raddr),
    .rdata(rdata)
);

// Write pointer and Gray code generation
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
    end else if (~wfull & winc) begin
        wptr_bin <= wptr_bin + 1;
        wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1); // Binary to Gray
    end
end

// Read pointer and Gray code generation
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
    end else if (~rempty & rinc) begin
        rptr_bin <= rptr_bin + 1;
        rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1); // Binary to Gray
    end
end

// Synchronize read pointer into write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_gray_sync1 <= 0;
        rptr_gray_sync2 <= 0;
    end else begin
        rptr_gray_sync1 <= rptr_gray;
        rptr_gray_sync2 <= rptr_gray_sync1;
    end
end

// Synchronize write pointer into read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_gray_sync1 <= 0;
        wptr_gray_sync2 <= 0;
    end else begin
        wptr_gray_sync1 <= wptr_gray;
        wptr_gray_sync2 <= wptr_gray_sync1;
    end
end

// Reconvert synchronized pointers (Gray to Binary)
wire [ADDR_WIDTH:0] wptr_bin_sync = wptr_gray_sync2 ^ (wptr_gray_sync2 >> 1);
wire [ADDR_WIDTH:0] rptr_bin_sync = rptr_gray_sync2 ^ (rptr_gray_sync2 >> 1);

// Empty and Full Signals
assign rempty = (wptr_gray_sync2 == rptr_gray);
assign wfull = (wptr_gray[ADDR_WIDTH] != rptr_gray_sync2[ADDR_WIDTH]) &&
               (wptr_gray[ADDR_WIDTH-1] != rptr_gray_sync2[ADDR_WIDTH-1]) &&
               (wptr_gray[ADDR_WIDTH-2:0] == rptr_gray_sync2[ADDR_WIDTH-2:0]);

endmodule