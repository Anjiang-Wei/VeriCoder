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

    output wire             wfull,    
    output wire             rempty,    
    output wire [WIDTH-1:0] rdata      
);

// Parameters and Addresses
parameter ADDR_WIDTH = $clog2(DEPTH);
parameter GRAY_WIDTH = ADDR_WIDTH;

// Dual-Port RAM Instance
wire                  ram_wren;
wire                  ram_rden;
wire [ADDR_WIDTH-1:0] ram_waddr;
wire [ADDR_WIDTH-1:0] ram_raddr;
wire [WIDTH-1:0]     ram_wdata;
wire [WIDTH-1:0]     ram_rdata;

dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(ram_wren),
    .waddr(ram_waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ram_rden),
    .raddr(ram_raddr),
    .rdata(rdata)
);

// Write and Read Pointers
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [GRAY_WIDTH-1:0] wptr = 0;
reg [GRAY_WIDTH-1:0] rptr = 0;
reg [GRAY_WIDTH-1:0] wptr_buff = 0;
reg [GRAY_WIDTH-1:0] rptr_buff = 0;

// Pointer Synchronization
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc && !wfull) begin
        waddr_bin <= waddr_bin + 1'b1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc && !rempty) begin
        raddr_bin <= raddr_bin + 1'b1;
    end
end

// Gray Code Logic
always @(posedge wclk) begin
    wptr <= (waddr_bin >> 1) ^ waddr_bin; // Convert to Gray code
end

always @(posedge rclk) begin
    rptr <= (raddr_bin >> 1) ^ raddr_bin;
end

// Buffering Pointers
always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Memory Addressing
assign ram_waddr = waddr_bin; // Direct mapping
assign ram_raddr = rptr_buff[ADDR_WIDTH-1:0]; // Use lower bits for address

// Read and Write Enabled Signals
assign ram_wren = winc && !wfull;
assign ram_rden = rinc && !rempty;

// Full and Empty Conditions
assign wfull = (wptr[GRAY_WIDTH-1] ^ rptr_buff[GRAY_WIDTH-1]) &&
                (wptr[GRAY_WIDTH-2:0] == rptr_buff[GRAY_WIDTH-2:0]);

assign rempty = (wptr == rptr_buff);

// Registering output data for read
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
    output reg  [WIDTH-1:0] rdata       
);

// Memory declaration
reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule