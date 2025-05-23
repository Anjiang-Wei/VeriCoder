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
    input       [WIDTH-1:0] wdata,
    output                  wfull,
    output                  rempty,
    output      [WIDTH-1:0] rdata
);

    // Address‐pointer widths
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // Write‐domain pointers
    reg  [PTR_WIDTH-1:0] wbin, wbin_next;
    reg  [PTR_WIDTH-1:0] wgray;
    // Synchronized (to wclk) copy of read‐pointer (Gray)
    reg  [PTR_WIDTH-1:0] rgray_sync1, rgray_sync2;

    // Read‐domain pointers
    reg  [PTR_WIDTH-1:0] rbin, rbin_next;
    reg  [PTR_WIDTH-1:0] rgray;
    // Synchronized (to rclk) copy of write‐pointer (Gray)
    reg  [PTR_WIDTH-1:0] wgray_sync1, wgray_sync2;

    // Full when next wptr_gray == {inv MSBs of rptr_gray_sync, rest same}
    assign wfull  = (wgray == { ~rgray_sync2[PTR_WIDTH-1],
                                 ~rgray_sync2[PTR_WIDTH-2],
                                  rgray_sync2[PTR_WIDTH-3:0] });
    // Empty when rptr_gray == wptr_gray_sync
    assign rempty = (rgray == wgray_sync2);

    //------------------------------------------------------------------
    // Write‐side pointer arithmetic & synchronization of rptr
    //------------------------------------------------------------------

    // compute next write‐pointer in binary
    always @* begin
        wbin_next = wbin + ({PTR_WIDTH{1'b0}} + (winc & ~wfull));
    end

    // update write‐pointer and gray‐code, and bring rgray into wclk domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wbin         <= 0;
            wgray        <= 0;
            rgray_sync1  <= 0;
            rgray_sync2  <= 0;
        end else begin
            wbin         <= wbin_next;
            wgray        <= wbin_next ^ (wbin_next >> 1);
            // two‐stage synchronizer for the read‐pointer
            rgray_sync1  <= rgray;
            rgray_sync2  <= rgray_sync1;
        end
    end

    //------------------------------------------------------------------
    // Read‐side pointer arithmetic & synchronization of wptr
    //------------------------------------------------------------------

    // compute next read‐pointer in binary
    always @* begin
        rbin_next = rbin + ({PTR_WIDTH{1'b0}} + (rinc & ~rempty));
    end

    // update read‐pointer and gray‐code, and bring wgray into rclk domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rbin         <= 0;
            rgray        <= 0;
            wgray_sync1  <= 0;
            wgray_sync2  <= 0;
        end else begin
            rbin         <= rbin_next;
            rgray        <= rbin_next ^ (rbin_next >> 1);
            // two‐stage synchronizer for the write‐pointer
            wgray_sync1  <= wgray;
            wgray_sync2  <= wgray_sync1;
        end
    end

    //------------------------------------------------------------------
    // Dual‐port RAM instantiation
    //------------------------------------------------------------------

    dual_port_RAM #(
        .WIDTH  (WIDTH),
        .DEPTH  (DEPTH)
    ) ram_inst (
        .wclk   (wclk),
        .wenc   (winc & ~wfull),
        .waddr  (wbin[ADDR_WIDTH-1:0]),
        .wdata  (wdata),
        .rclk   (rclk),
        .renc   (rinc & ~rempty),
        .raddr  (rbin[ADDR_WIDTH-1:0]),
        .rdata  (rdata)
    );

endmodule


//------------------------------------------------------------------------------
// Dual‐Port RAM: independent read/write clocks, addresses & enables
//------------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    // RAM storage
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule