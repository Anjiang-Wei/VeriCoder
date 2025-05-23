module asyn_fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                     wclk    , 
    input                     rclk    ,   
    input                     wrstn   ,
    input                     rrstn   ,
    input                     winc    ,
    input                     rinc    ,
    input      [WIDTH-1:0]    wdata   ,

    output wire               wfull   ,
    output wire               rempty  ,
    output reg  [WIDTH-1:0]   rdata
);

    parameter ADDR_WIDTH = $clog2(DEPTH);

    // Internal signals
    reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;     // Binary write and read pointers
    reg [ADDR_WIDTH:0] wptr_gray, rptr_gray;  // Gray-coded pointers
    reg [ADDR_WIDTH:0] wptr_gray_syn, rptr_gray_syn; // Synchronized Gray-code pointers
    reg [ADDR_WIDTH:0] waddr_bin, raddr_bin;  // Binary address for the dual-port RAM

    // Wires for dual-port RAM
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    // Reset logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1;
    end

    // Binary to Gray code conversion
    always @(*) begin
        wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
        rptr_gray = (rptr_bin >> 1) ^ rptr_bin;
    end

    // Pointer synchronization between clock domains
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            rptr_gray_syn <= 0;
        else
            rptr_gray_syn <= {rptr_gray_syn[ADDR_WIDTH-1:1], rptr_gray};
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            wptr_gray_syn <= 0;
        else
            wptr_gray_syn <= {wptr_gray_syn[ADDR_WIDTH-1:1], wptr_gray};
    end

    // Determine the empty and full states
    assign rempty = (rptr_gray_syn == wptr_gray);
    assign wfull = ((wptr_gray[ADDR_WIDTH] != rptr_gray_syn[ADDR_WIDTH]) &&
                    (wptr_gray[ADDR_WIDTH-1] != rptr_gray_syn[ADDR_WIDTH-1]) &&
                     (wptr_gray[ADDR_WIDTH-2:0] == rptr_gray_syn[ADDR_WIDTH-2:0]));

    // Extract addresses for RAM
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(winc && !wfull), // Write enable logic
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty), // Read enable logic
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


module dual_port_RAM#(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input                    wclk   , // Write clock
    input                    wenc   , // Write enable
    input   [$clog2(DEPTH)-1:0] waddr , // Write address
    input   [WIDTH-1:0]      wdata  , // Write data

    input                    rclk   , // Read clock
    input                    renc   , // Read enable
    input   [$clog2(DEPTH)-1:0] raddr , // Read address
    output reg [WIDTH-1:0]   rdata    // Read data
);

    // Define the RAM as a 2D array
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

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