module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0]dout_parallel,
    output reg dout_valid
);

// 4-bit counter to track received data bits
reg [3:0] cnt;

always @(posedge clk) begin
    if (~rst_n) begin
        // Reset the counter on asynchronous reset
        cnt <= 0;
        dout_valid <= 0;
        // Clear the output register for a new sequence
        dout_parallel <= 8'b00000000;
    end else if (din_valid) begin
        // Increment the counter on each valid data input
        cnt <= cnt + 1;

        case (cnt)
            4'd0: begin
                // Shift in new serial data when cnt is less than 8
                dout_parallel[7] <= din_serial;
            end

            4'd1: begin
                dout_parallel[6] <= din_serial;
            end

            4'd2: begin
                dout_parallel[5] <= din_serial;
            end

            4'd3: begin
                dout_parallel[4] <= din_serial;
            end

            default: begin
                // Once all 8 bits have been received, set the output valid signal to 1
                if (cnt == 4'd7) begin
                    dout_valid <= 1;
                end else begin
                    // Shift in remaining serial data
                    case (cnt)
                        4'd4: begin
                            dout_parallel[3] <= din_serial;
                        end

                        4'd5: begin
                            dout_parallel[2] <= din_serial;
                        end

                        4'd6: begin
                            dout_parallel[1] <= din_serial;
                        end

                        4'd7: begin
                            dout_parallel[0] <= din_serial;
                        end
                    endcase
                end
            end
        endcase
    end
end

endmodule