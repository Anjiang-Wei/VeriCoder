module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

    reg [7:0] SR;
    reg [7:0] NEG_DIVISOR;
    reg [7:0] cnt;
    reg [7:0] start_cnt;
    reg [15:0] res;
    reg [15:0] temp;
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [7:0] temp_SR;
    reg [7:0] temp_NEG_DIVISOR;
    reg [7:0] temp_cnt;
    reg [7:0] temp_start_cnt;
    reg [15:0] temp_res;
    reg [15:0] temp_temp;
    reg [7:0] temp_temp_dividend;
    reg [7:0] temp_temp_divisor;
    reg [7:0] temp_temp_SR;
    reg [7:0] temp_temp_NEG_DIVISOR;
    reg [7:0] temp_temp_cnt;
    reg [7:0] temp_temp_start_cnt;
    reg [15:0] temp_temp_res;
    reg [15:0] temp_temp_temp;
    reg [7:0] temp_temp_temp_dividend;
    reg [7:0] temp_temp_temp_divisor;
    reg [7:0] temp_temp_temp_SR;
    reg [7:0] temp_temp_temp_NEG_DIVISOR;
    reg [7:0] temp_temp_temp_cnt;
    reg [7:0] temp_temp_temp_start_cnt;
    reg [15:0] temp_temp_temp_res;
    reg [15:0] temp_temp_temp_temp;
    reg [7:0] temp_temp_temp_temp_dividend;
    reg [7:0] temp_temp_temp_temp_divisor;
    reg [7:0] temp_temp_temp_temp_SR;
    reg [7:0] temp_temp_temp_temp_NEG_DIVISOR;
    reg [7:0] temp_temp_temp_temp_cnt;
    reg [7:0] temp_temp_temp_temp_start_cnt;
    reg [15:0] temp_temp_temp_temp_res;
    reg [15:0] temp_temp_temp_temp_temp;
    reg [7:0] temp_temp_temp_temp_temp_dividend;
    reg [7:0] temp_temp_temp_temp_temp_divisor;
    reg [7:0] temp_temp_temp_temp_temp_SR;
    reg [7:0] temp_temp_temp_temp_temp_NEG_DIVISOR;
    reg [7:0] temp_temp_temp_temp_temp_cnt;
    reg [7:0] temp_temp_temp_temp_temp_start_cnt;
    reg [15:0] temp_temp_temp_temp_temp_res;
    reg [15:0] temp_temp_temp_temp_temp_temp;
    reg [7:0] temp_temp_temp_temp_temp_temp_dividend;
    reg [7:0] temp_temp_temp_temp_temp_temp_divisor;
    reg [7:0] temp_temp_temp_temp_temp_temp_SR;
    reg [7:0] temp_temp_temp_temp_temp_temp_NEG_DIVISOR;
    reg [7:0] temp_temp_temp_temp_temp_temp_cnt;
    reg [7:0] temp_temp_temp_temp_temp_