module asyn_fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input 			wclk	, 
    input 			rclk	,   
    input 			wrstn	,
    input		rrstn	,
    input 			winc	,
    input 			rinc	,
    input [WIDTH-1:0] wdata	,
    
    output wire		wfull	,
    output wire		rempty	,
    output wire [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

// Dual Port RAM Instantiation
dual_port_ram dual_port_RAM (
    .wclkin (wclk),
    .rclkin (rclk),
    .wraddr (waddr),
    .wrdata (wdata),
    .rdaddr (raddr),
    .rdata (rdata),
    .wen (wrstn),
    .ren (rrstn),
    .winc (winc),
    .rin (rinc)
);

// Write Pointer Management
wire [ADDR_WIDTH-1:0] wptr;
wire [ADDR_WIDTH-1:0] rptr;

assign wptr = (wrstn ? 0 : ~wdata[ADDR_WIDTH-1:0]);
assign rptr = (rrstn ? 0 : ~rdata[ADDR_WIDTH-1:0]);

// Read Pointer Management
wire [ADDR_WIDTH-1:0] waddr_bin;
wire [ADDR_WIDTH-1:0] raddr_bin;

assign waddr_bin = (winc ? wdata : wptr);
assign raddr_bin = (rinc ? rdata : rptr);

// Gray Code Conversion for Write and Read Pointers
wire [ADDR_WIDTH-1:0] wptr_syn;
wire [ADDR_WIDTH-1:0] rptr_syn;

assign wptr_syn = (wrstn ? ~wdata[ADDR_WIDTH-1:0] : 
                        (rdata[ADDR_WIDTH-1:0] ^ wdata[ADDR_WIDTH-1:0])[ADDR_WIDTH-1:0]);
assign rptr_syn = (rrstn ? ~rdata[ADDR_WIDTH-1:0] : 
                        (wdata[ADDR_WIDTH-1:0] ^ rdata[ADDR_WIDTH-1:0])[ADDR_WIDTH-1:0]);

// Full and Empty Signals
wire full;
wire empty;

assign full = (wptr == rptr_syn);
assign empty = (!full && wdata !== rdata);

endmodule