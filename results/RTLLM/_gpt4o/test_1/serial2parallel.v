module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt; // 4-bit counter to track the number of received bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin // Asynchronous active-low reset
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            cnt <= 4'b0;
        end else begin
            if (din_valid) begin // If input data is valid
                // Shift in the incoming serial bit into dout_parallel
                dout_parallel <= {dout_parallel[6:0], din_serial};
                cnt <= cnt + 1;

                if (cnt == 4'd7) begin
                    dout_valid <= 1'b1; // Output is valid when 8 bits have been received
                end else begin
                    dout_valid <= 1'b0; // Not valid until we've received 8 bits
                end
            end
        end
    end

endmodule