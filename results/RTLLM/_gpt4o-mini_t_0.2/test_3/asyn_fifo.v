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

// Dual-port RAM instantiation
wire [WIDTH-1:0] ram_rdata;
wire [ADDR_WIDTH-1:0] waddr, raddr;
wire wenc, renc;

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
    .rdata(ram_rdata)
);

// Write and Read Pointer registers
reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
reg [ADDR_WIDTH-1:0] wptr, rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;

// Full and Empty Signals
assign wfull = (wptr[ADDR_WIDTH-1] != rptr[ADDR_WIDTH-1]) && (wptr[ADDR_WIDTH-2:0] == rptr[ADDR_WIDTH-2:0]);
assign rempty = (wptr == rptr);

// Write Pointer Synchronization
reg [ADDR_WIDTH:0] wptr_sync;
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

assign rptr = {~(rptr_buff[ADDR_WIDTH-1] ^ wptr[ADDR_WIDTH-1]), rptr_buff[ADDR_WIDTH-2:0]};

// Read Pointer Synchronization
reg [ADDR_WIDTH:0] rptr_sync;
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

assign wptr = {~(wptr_buff[ADDR_WIDTH-1] ^ rptr[ADDR_WIDTH-1]), wptr_buff[ADDR_WIDTH-2:0]};

// RAM Addressing
assign waddr = waddr_bin;
assign raddr = rptr[ADDR_WIDTH-2:0];

// Write and Read Control Logic
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc && !wfull) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc && !rempty) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Write and Read Enable Signals
assign wenc = winc && !wfull;
assign renc = rinc && !rempty;

// Read Data Output
assign rdata = ram_rdata;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,        // Write clock
    input                   wenc,        // Write enable
    input       [$clog2(DEPTH)-1:0] waddr, // Write address
    input       [WIDTH-1:0] wdata,      // Write data
    input                   rclk,        // Read clock
    input                   renc,        // Read enable
    input       [$clog2(DEPTH)-1:0] raddr, // Read address
    output reg  [WIDTH-1:0] rdata       // Read data
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1]; // RAM memories

// Write Logic
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read Logic
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule