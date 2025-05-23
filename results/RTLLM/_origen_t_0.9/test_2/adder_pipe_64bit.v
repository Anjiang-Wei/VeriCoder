Please complete the Verilog code below and return the complete module code directly:
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

reg [DATA_WIDTH:0] i_en_r;
reg [STG_WIDTH-1:0] o_en_r;
reg [DATA_WIDTH-1:0] adda_r [STG_WIDTH-1:0];
reg [DATA_WIDTH-1:0] addb_r [STG_WIDTH-1:0];
reg [DATA_WIDTH:0] result_r [STG_WIDTH-1:0];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_en_r <= 0;
        o_en_r <= 0;
        for (i = 0; i < STG_WIDTH; i = i + 1) begin
            adda_r[i] <= 0;
            addb_r[i] <= 0;
            result_r[i] <= 0;
        end
    end
    else begin
        i_en_r <= {i_en_r[STG_WIDTH-2:0], i_en};
        o_en_r <= {o_en_r[STG_WIDTH-2:0], o_en_r[STG_WIDTH-1]};
        adda_r[0] <= adda;
        addb_r[0] <= addb;
        result_r[0] <= {1'b0, adda} + {1'b0, addb};
        for (i = 1; i < STG_WIDTH; i = i + 1) begin
            adda_r[i] <= adda_r[i-1];
            addb_r[i] <= addb_r[i-1];
            result_r[i] <= result_r[i-1] + {1'b0, adda_r[i-1]} + {1'b0, addb_r[i-1]};
        end
    end
end

assign result = result_r[STG_WIDTH-1];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 1'b0;
    end
    else begin
        o_en <= o_en_r[STG_WIDTH-1];
    end
end

endmodule