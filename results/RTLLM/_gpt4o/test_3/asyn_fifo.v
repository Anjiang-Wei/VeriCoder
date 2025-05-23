module asyn_fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk    , 
    input                   rclk    ,   
    input                   wrstn   ,
    input                   rrstn   ,
    input                   winc    ,
    input                   rinc    ,
    input       [WIDTH-1:0] wdata   ,

    output reg              wfull   ,
    output reg              rempty  ,
    output reg  [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// ---------------------------------------------------------------------------
// Internal signal declarations for read and write pointers and synchronization
reg  [ADDR_WIDTH:0]   wptr_bin, rptr_bin;    // Binary write and read pointers
reg  [ADDR_WIDTH:0]   wptr_gray, rptr_gray; // Gray-coded write and read pointers
reg  [ADDR_WIDTH:0]   wptr_gray_sync1, wptr_gray_sync2; // Synchronized write pointer for rclk domain
reg  [ADDR_WIDTH:0]   rptr_gray_sync1, rptr_gray_sync2; // Synchronized read pointer for wclk domain

// Memory address signals
wire [ADDR_WIDTH-1:0] waddr;
wire [ADDR_WIDTH-1:0] raddr;

// Write enable and read enable signals for the RAM
wire wenc = winc && ~wfull;
wire renc = rinc && ~rempty;

// Subset assignments of binary pointers for addressing the RAM
assign waddr = wptr_bin[ADDR_WIDTH-1:0];
assign raddr = rptr_bin[ADDR_WIDTH-1:0];

// ---------------------------------------------------------------------------
// Dual-port RAM instantiation for storage
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) fifo_mem (
    .wclk   (wclk    ),
    .wenc   (wenc    ),
    .waddr  (waddr   ),
    .wdata  (wdata   ),
    
    .rclk   (rclk    ),
    .renc   (renc    ),
    .raddr  (raddr   ),
    .rdata  (rdata   )
);

// ---------------------------------------------------------------------------
// Write Pointer Management
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_bin  <= 0;
        wptr_gray <= 0;
    end else if (wenc) begin
        wptr_bin  <= wptr_bin + 1;
        wptr_gray <= wptr_bin ^ (wptr_bin >> 1); // Convert to Gray code
    end
end

// ---------------------------------------------------------------------------
// Read Pointer Management
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_bin  <= 0;
        rptr_gray <= 0;
    end else if (renc) begin
        rptr_bin  <= rptr_bin + 1;
        rptr_gray <= rptr_bin ^ (rptr_bin >> 1); // Convert to Gray code
    end
end

// ---------------------------------------------------------------------------
// Synchronize Write Pointer to Read Clock Domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        {wptr_gray_sync2, wptr_gray_sync1} <= 0;
    end else begin
        {wptr_gray_sync2, wptr_gray_sync1} <= {wptr_gray_sync1, wptr_gray};
    end
end

// ---------------------------------------------------------------------------
// Synchronize Read Pointer to Write Clock Domain
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        {rptr_gray_sync2, rptr_gray_sync1} <= 0;
    end else begin
        {rptr_gray_sync2, rptr_gray_sync1} <= {rptr_gray_sync1, rptr_gray};
    end
end

// ---------------------------------------------------------------------------
// Empty and Full Status Logic
always @(*) begin
    // Empty: Read pointer matched synchronized write pointer
    rempty = (rptr_gray == wptr_gray_sync2);

    // Full: Write pointer has one more cycle than synchronized read pointer
    wfull = (wptr_gray[ADDR_WIDTH] != rptr_gray_sync2[ADDR_WIDTH]) &&
            (wptr_gray[ADDR_WIDTH-1] != rptr_gray_sync2[ADDR_WIDTH-1]) &&
            (wptr_gray[ADDR_WIDTH-2:0] == rptr_gray_sync2[ADDR_WIDTH-2:0]);
end

endmodule

// ---------------------------------------------------------------------------
// Dual-Port RAM Implementation
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   wenc,
    input   [$clog2(DEPTH)-1:0] waddr,
    input   [WIDTH-1:0]     wdata,

    input                   rclk,
    input                   renc,
    input   [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);
    // Memory array
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
        end
    end
endmodule