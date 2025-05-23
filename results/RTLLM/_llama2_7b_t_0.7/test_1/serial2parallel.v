module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0]dout_parallel,
    output reg dout_valid
) {
  // Counter to keep track of received serial bits
  localparam COUNT_WIDTH = 4;
  reg [COUNT_WIDTH-1:0] cnt = 0;

  always @(posedge clk or negedge rst_n) begin
    // Reset the counter on reset
    if (rst_n) cnt <= 0;

    // Increment the counter on each serial input bit received
    else if (din_serial && din_valid) cnt <= cnt + 1;

    // Output parallel data every 8 serial bits received
    if (cnt >= 8) begin
      dout_parallel <= din_serial[7:0];
      dout_valid <= 1;
      cnt <= 0;
    end
  end
}