### Response:
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    
    output wire wfull,
    output wire rempty,
    output wire [WIDTH-1:0] rdata
);

    parameter ADDR_WIDTH = $clog2(DEPTH);

    reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
    reg [ADDR_WIDTH:0] wptr, rptr;
    reg [ADDR_WIDTH:0] wptr_buff, rptr_buff;
    
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire wenc, ren;
    wire wfull_syn, rempty_syn;
    wire [WIDTH-1:0] rdata_ram;

    // Gray code conversion
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1'b1;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1'b1;
        end
    end

    assign wptr = {waddr_bin ^ (waddr_bin >> 1), waddr_bin[0]};
    assign rptr = {raddr_bin ^ (raddr_bin >> 1), raddr_bin[0]};

    // Write pointer synchronizer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
        end
    end

    // Read pointer synchronizer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
        end
    end

    // Full and empty detection
    assign wfull_syn = (wptr[ADDR_WIDTH] != rptr_buff[ADDR_WIDTH]) && 
                       (wptr[ADDR_WIDTH-1:0] == rptr_buff[ADDR_WIDTH-1:0]);
    assign rempty_syn = (rptr == wptr_buff);

    assign wfull = wfull_syn;
    assign rempty = rempty_syn;

    // Dual-port RAM instantiation
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata_ram)
    );

    assign waddr = waddr_bin;
    assign raddr = raddr_bin;
    assign wenc = winc && !wfull;
    assign ren = rinc && !rempty;
    assign rdata = rdata_ram;

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wire wclk,
    input wire wenc,
    input wire [$clog2(DEPTH)-1:0] waddr,
    input wire [WIDTH-1:0] wdata,
    input wire rclk,
    input wire renc,
    input wire [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] ram_mem [0:DEPTH-1];

    always @(posedge wclk) begin