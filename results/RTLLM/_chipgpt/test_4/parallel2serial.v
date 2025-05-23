module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

wire cnt;
reg [1:0] data = {&d};

always @(posedge clk)
    if (rst_n) data <= 0;
    else if (!data[3]) cnt <= 0;
    else cnt <= cnt + 1;

always @(*)
    if (cnt == 0) {valid_out, dout} = ~data && !(data < 4'd7); // When the counter is 3, the most significant bit of data will be moved to least significant position.
    else {valid_out, dout} = data[1:0] == 4'b0 ? valid_out : ~data;

endmodule