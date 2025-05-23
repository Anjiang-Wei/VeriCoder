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

// 16-stage pipeline with four registers per stage to enable the pipelining operation
reg [STG_WIDTH*4-1:0] stg_reg1;
reg [STG_WIDTH*4-1:0] stg_reg2;
reg [STG_WIDTH*4-1:0] stg_reg3;
reg [STG_WIDTH*4-1:0] stg_reg4;
// registers for register transfer operation
wire [DATA_WIDTH-1:0] stg_reg1_d;
wire [DATA_WIDTH-1:0] stg_reg2_d;
wire [DATA_WIDTH-1:0] stg_reg3_d;
wire [DATA_WIDTH-1:0] stg_reg4_d;
// output register of the 16th stage
reg [STG_WIDTH*4-1:0] next_stg_reg1;
// output register of the 2nd stage
reg [3:0] sum;
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        stg_reg1 <= 'd0;
        stg_reg2 <= 'd0;
        stg_reg3 <= 'd0;
        stg_reg4 <= 'd0;
    end
    else begin
        if (i_en && ~o_en) begin
            next_stg_reg1 = stg_reg1;
            sum = 0;
            for(int i=0; i<STG_WIDTH*4; i=i+1) begin
                sum[i+1:i] = stg_reg1[i] + adda[i];
            end
        o_en <= 0;
            stg_reg1[STG_WIDTH-1:0] = result[DATA_WIDTH-1:STG_WIDTH*2];
            stg_reg1[STG_WIDTH*4-1:DATA_WIDTH] = sum; // result of previous stage is used as input for next stage
        end
    else
         o_en <= 0;
        stg_reg2 <= stg_reg1;
        stg_reg3 <= stg_reg2;
        stg_reg4 <= stg_reg3;
    end // if-else block
end // always block
// register transfer operation of the 16th stage
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) result[DATA_WIDTH*4-1:0] <= 'd0;
    else o_en <= (i_en && ~o_en); // output enable signal is updated based on the pipeline stages and synchronized with the clock (clk) and reset (rst_n) signals. If i_en is true, then the next 16th stage will be enabled
    for(int i=0; i<STG_WIDTH*4; i=i+1) begin
        result[DATA_WIDTH*4-1:0] = stg_reg4[i] + addb[i]; // output of next 2nd, 3rd and 4th stage is used as input for this register transfer operation. The sum of two operands is the new value of the previous register
    end
end
// register transfer operation of second stage
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) result[DATA_WIDTH-1:0] <= 'd0;
    else o_en <= i_en && ~o_en; // output enable signal is updated based on the pipeline stages and synchronized with the clock (clk) and reset (rst_n) signals. If i_en is true, then the next 2nd stage will be enabled
    if(i_en && o_en) result[DATA_WIDTH-1:0] = stg_reg3_d; // result of register transfer operation is used as input for next register transfer operation
end
// register transfer operation of third stage
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) result[DATA_WIDTH-1:0] <= 'd0;
    else o_en <= i_en && ~o_en; // output enable signal is updated based on the pipeline stages and synchronized with the clock (clk) and reset (rst_n) signals. If i_en is true, then the next 3rd stage will be enabled
    if(i_en && o_en) result[DATA_WIDTH-1:0] = stg_reg2_d; // result of register transfer operation is used as input for next register transfer operation
end
// register transfer operation of fourth stage
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) stg_reg1[DATA_WIDTH*4-1:0] <= 'd0;
    else o_en <= i_en && ~o_en; // output enable signal is updated based on the pipeline stages and synchronized with the clock (clk) and reset (rst_n) signals. If i_en is true, then the next 4th stage will be enabled
    if(i_en && o_en) stg_reg1[DATA_WIDTH*4-1:0] = stg_reg4_d; // result of register transfer operation is used as input for next register transfer operation
end

endmodule