module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0]dout_parallel,
    output reg dout_valid
) {
    // Counter to keep track of received serial data bits
    always #10 clk => (cnt <= 7) -> cnt <= cnt + 1;

    // Output the parallel data when enough serial data has been received
    assign dout_parallel = {din_serial[7], din_serial[6], din_serial[5], din_serial[4], din_serial[3], din_serial[2], din_serial[1], din_serial[0]};

    // Set the valid output signal when enough serial data has been received
    assign dout_valid = (cnt == 8);
}