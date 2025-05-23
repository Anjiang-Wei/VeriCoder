//-----------------------------------------------------------------------------
// Dual‐port RAM submodule
//-----------------------------------------------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                    wclk,
    input                    wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]       wdata,
    input                    rclk,
    input                    renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]   rdata
);

    // memory array
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // write port
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // read port
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule


//-----------------------------------------------------------------------------
// Asynchronous FIFO
//-----------------------------------------------------------------------------
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
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    // address width and pointer width
    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // internal wires
    wire                   wenc     = winc  & ~wfull;
    wire                   renc     = rinc  & ~rempty;
    wire [ADDR_WIDTH-1:0]  waddr    = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0]  raddr    = rptr_bin[ADDR_WIDTH-1:0];

    // binary pointers
    reg  [PTR_WIDTH-1:0]   wptr_bin;
    reg  [PTR_WIDTH-1:0]   rptr_bin;

    // Gray‑code pointers
    reg  [PTR_WIDTH-1:0]   wptr_gray;
    reg  [PTR_WIDTH-1:0]   rptr_gray;

    // synch registers for crossing domains
    reg  [PTR_WIDTH-1:0]   rptr_gray_w1, rptr_gray_w2; // read pointer into write domain
    reg  [PTR_WIDTH-1:0]   wptr_gray_r1, wptr_gray_r2; // write pointer into read domain

    //------------------------------------------------------------------------
    // Write-domain logic: binary ptr, gray convert, sync read‑ptr
    //------------------------------------------------------------------------
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin     <= {PTR_WIDTH{1'b0}};
            wptr_gray    <= {PTR_WIDTH{1'b0}};
            rptr_gray_w1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_w2 <= {PTR_WIDTH{1'b0}};
        end else begin
            // increment binary write pointer
            if (wenc)
                wptr_bin <= wptr_bin + 1'b1;
            // binary->gray conversion
            wptr_gray <= (wptr_bin >> 1) ^ wptr_bin;
            // synchronize read‑domain gray pointer into write clock
            rptr_gray_w1 <= rptr_gray;
            rptr_gray_w2 <= rptr_gray_w1;
        end
    end

    //------------------------------------------------------------------------
    // Read-domain logic: binary ptr, gray convert, sync write‑ptr
    //------------------------------------------------------------------------
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin     <= {PTR_WIDTH{1'b0}};
            rptr_gray    <= {PTR_WIDTH{1'b0}};
            wptr_gray_r1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_r2 <= {PTR_WIDTH{1'b0}};
        end else begin
            // increment binary read pointer
            if (renc)
                rptr_bin <= rptr_bin + 1'b1;
            // binary->gray conversion
            rptr_gray <= (rptr_bin >> 1) ^ rptr_bin;
            // synchronize write‑domain gray pointer into read clock
            wptr_gray_r1 <= wptr_gray;
            wptr_gray_r2 <= wptr_gray_r1;
        end
    end

    //------------------------------------------------------------------------
    // Full flag: when write pointer is one cycle ahead of read pointer
    //   in Gray code: high two bits are inverted, lower bits equal
    //------------------------------------------------------------------------
    assign wfull  = ( wptr_gray
                     == { ~rptr_gray_w2[PTR_WIDTH-1],
                          ~rptr_gray_w2[PTR_WIDTH-2],
                           rptr_gray_w2[PTR_WIDTH-3:0] }
                    );

    //------------------------------------------------------------------------
    // Empty flag: when read pointer equals synchronized write pointer
    //------------------------------------------------------------------------
    assign rempty = (rptr_gray == wptr_gray_r2);

    //------------------------------------------------------------------------
    // Instantiate dual-port RAM
    //------------------------------------------------------------------------
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk   (wclk),
        .wenc   (wenc),
        .waddr  (waddr),
        .wdata  (wdata),
        .rclk   (rclk),
        .renc   (renc),
        .raddr  (raddr),
        .rdata  (rdata)
    );

endmodule