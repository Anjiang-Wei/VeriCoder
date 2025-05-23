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

parameter ADDR_WIDTH = $clog2(DEPTH);

// Write and Read pointers
reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
reg [ADDR_WIDTH:0] wptr, rptr;
reg [ADDR_WIDTH:0] wptr_buff, rptr_buff;
wire [ADDR_WIDTH:0] wptr_gray, rptr_gray;

// Dual-port RAM instance
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Write logic
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) 
        waddr_bin <= 0;
    else if (winc && ~wfull)
        waddr_bin <= waddr_bin + 1;
end

// Read logic
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn)
        raddr_bin <= 0;
    else if (rinc && ~rempty)
        raddr_bin <= raddr_bin + 1;
end

// Gray code conversion
assign wptr_gray = {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1:1] ^ waddr_bin[ADDR_WIDTH-2:0]};
assign rptr_gray = {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1:1] ^ raddr_bin[ADDR_WIDTH-2:0]};

// Pointer synchronization
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn)
        wptr_buff <= 0;
    else
        wptr_buff <= wptr_gray;
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn)
        rptr_buff <= 0;
    else
        rptr_buff <= rptr_gray;
end

// Determine full and empty conditions
assign rempty = (wptr_buff == rptr_buff);
assign wfull = (wptr_buff[ADDR_WIDTH] ^ rptr_buff[ADDR_WIDTH]) && (wptr_buff[ADDR_WIDTH-1:0] == rptr_buff[ADDR_WIDTH-1:0]);

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]        wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]    rdata
);

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