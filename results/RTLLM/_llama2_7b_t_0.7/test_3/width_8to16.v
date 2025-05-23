module width_8to16 (
    input  clk,
    input rst_n,
    input valid_in,
    input data_in,

    output reg valid_out,
    output reg [15:0] data_out
);

// Data_out register
module width_8to16_data_out (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,

    output reg [15:0] data_out
);

width_8to16_data_out dut (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .data_in(data_in),
    .data_out(data_out)
);

// Top-level module
module width_8to16 (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .data_in(data_in),

    .valid_out(valid_out),
    .data_out(data_out)
);
endmodule