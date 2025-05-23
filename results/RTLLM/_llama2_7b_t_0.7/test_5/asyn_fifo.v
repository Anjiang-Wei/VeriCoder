module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input [WIDTH-1:0] wdata,

    output wire wfull,
    output wire rempty,
    output wire [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

dual_port_ram # (
    parameter WIDTH = WIDTH,
    parameter DEPTH = DEPTH
) ram (
    input wire wrstn,
    input wire rrstn,
    input [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata
);

wfull <= (wrptr_syn XOR rempty) & (!wrstn);
rempty <= (rptr_syn XOR wfull) & (!rrstn);

 wrptr_syn <= wenc & waddr;
 rptr_syn <= renc & raddr;

waddr_bin <= wdata & ADDR_WIDTH[WRITESLOT-1:0];
raddr_bin <= rdata & ADDR_WIDTH[READSLOT-1:0];

wptr_buff <= wptr;
rptr_buff <= rptr;

wptr <= wptr_syn;
rptr <= rptr_syn;

endmodule