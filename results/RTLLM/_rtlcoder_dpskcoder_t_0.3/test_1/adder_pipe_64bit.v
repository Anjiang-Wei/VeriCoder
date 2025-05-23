The complete code is as follows:

```verilog
module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output reg o_en
);

    reg [DATA_WIDTH:0] sum [STG_WIDTH-1:0];
    reg [STG_WIDTH-1:0] en;
    reg [STG_WIDTH-1:0] en_sync;
    reg [STG_WIDTH-1:0] en_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync;
    reg [STG_WIDTH-1:0] en_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_sync_