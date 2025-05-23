module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
) {
    // Define the counter and data registers
    localparam CNT = 4; // Number of bits in the counter register
    reg [CNT-1:0] cnt = 0; // Counter register
    wire [3:0] data = d; // Data register

    // Assign the most significant bit of the parallel input to the serial output
    assign dout = data[3];

    // Valid signal for the serial output
    reg valid_out = (data[0] === cnt[3]) ? 1'b1 : 1'b0;

    // Update the counter and data registers on each clock cycle
    always @(posedge clk) begin
        if (rst_n) begin
            cnt <= 0;
            data <= 4'b0;
        end else begin
            if (cnt[3]) begin
                // Reset the counter and shift the data register one bit to the left
                cnt <= cnt - 1;
                data <= data << 1;
            end else begin
                // Increment the counter and set the valid signal based on the last bit of the parallel input
                cnt <= cnt + 1;
                valid_out <= valid_out && (data[0] === cnt[3]);
            end
        end
    end
}