module asyn_fifo#(
    parameter	WIDTH = 8,
    parameter 	DEPTH = 16
)(
    input 					wclk	, 
    input 					rclk	,   
    input 					wrstn	,
    input					rrstn	,
    input 					winc	,
    input 			 		rinc	,
    input 		[WIDTH-1:0]	wdata	,

    output wire				wfull	,
    output wire				rempty	,
    output wire [WIDTH-1:0]	rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);
parameter DEPTH_WIDTH = ADDR_WIDTH;

reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

reg [$clog2(DEPTH)-1:0] wptr_gray; // Gray code representation of write pointer
reg [$clog2(DEPTH)-1:0] rptr_gray; // Gray code representation of read pointer

reg [$clog2(DEPTH)-1:0] waddr;
reg [$clog2(DEPTH)-1:0] raddr;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0]; // Dual-port RAM memory array
reg [$clog2(DEPTH)-1:0] wptr; // Synchronized write pointer
reg [$clog2(DEPTH)-1:0] rptr_syn; // Synchronized read pointer

wire wen;
wire ren;

// Data Write Controller
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1'd1;
    end
end

assign wen = winc & ~wfull;

// Data Read Controller
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1'd1;
    end
end

assign ren = rinc & ~rempty;

// Dual-Port RAM Module Instantiation
module dual_port_RAM#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input clk,
    input en,
    input [$clog2(DEPTH)-1:0] addr,
    input [WIDTH-1:0] data,
    output reg [WIDTH-1:0] qdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge clk) begin
    if (en) begin
        RAM_MEM[addr] <= data;
    end
end

assign qdata = RAM_MEM[addr];
endmodule

dual_port_RAM dual_port_RAM_inst(
    .clk(wclk),
    .en(wen),
    .addr(waddr),
    .data(wdata),
    .qdata(RAM_MEM[waddr])
);

always @(posedge wclk) begin
    // Convert write pointer to Gray code
    wptr_gray <= ($signed({wptr_gray[ADDR_WIDTH-2:0], 1'b0}) ^ $signed({wptr_gray[ADDR_WIDTH-2:0], 1'b1})) >> ADDR_WIDTH-2;
end

always @(posedge rclk) begin
    // Convert read pointer to Gray code
    rptr_gray <= ($signed({rptr_gray[ADDR_WIDTH-2:0], 1'b0}) ^ $signed({rptr_gray[ADDR_WIDTH-2:0], 1'b1})) >> ADDR_WIDTH-2;
end

always @(posedge wclk) begin
    // Synchronize write pointer with Gray code representation
    if (~wrstn || winc) begin
        waddr <= waddr_bin;
        wptr <= wptr_gray;
    end else begin
        waddr <= waddr;
        wptr <= wptr;
    end
end

always @(posedge rclk) begin
    // Synchronize read pointer with Gray code representation
    if (~rrstn || rinc) begin
        raddr <= raddr_bin;
        rptr_syn <= rptr_gray;
    end else begin
        raddr <= raddr;
        rptr_syn <= rptr_syn;
    end
end

// Output logic for wfull and rempty signals
always @(*) begin
    // Check if FIFO is full (write pointer equals bitwise negation of most significant bit of read pointer concatenated with remaining bits of read pointer)
    if (wptr_syn == ~{1'b1, rptr_syn[ADDR_WIDTH-2:0]}) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end

    // Check if FIFO is empty (read pointer equals write pointer)
    if (rptr_syn == wptr_syn) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

// Connect read data to output
assign rdata = RAM_MEM[raddr];

endmodule // asyn_fifo module