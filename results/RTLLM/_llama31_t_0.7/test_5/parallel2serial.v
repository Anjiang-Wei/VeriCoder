module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg [1:0] dout
);

// Counter register to keep track of the current bit being processed
reg [2:0] cnt;

// Data register to store the parallel data
reg [4:0] data;

always @(posedge clk) begin
    if (~rst_n) begin
        // Reset the counter and data registers on active reset
        cnt <= 3'd0;
        data <= 'd0;
    end else begin
        case (cnt)
            3'b000: begin
                // Update data register with new parallel input on last bit
                data <= d;
                valid_out <= 1'b1; // Set valid signal to indicate serial output ready
                dout[1] <= d[0]; // Output most significant bit of parallel input
                dout[0] <= 'b0; // Initialize least significant bit to zero (will be updated later)
            end
            default: begin
                if (~valid_out) begin // Only increment counter and shift data when valid signal is low
                    cnt <= cnt + 1;
                    valid_out <= 1'b0; // Reset valid signal for next cycle
                    data <= {data[4], data[3:0]}; // Shift data register one bit to the left
                end
            end
        endcase
    end
end

// Output serial output (valid and dout) on valid_out high
always @(posedge clk)
    if (~rst_n && valid_out)
        begin
            case(cnt)
                3'b000: begin // Output most significant bit of parallel input
                    $display("MSB = %b", d[0]);
                    dout <= {dout, d[0]};
                end
                3'b001: begin // Output next bit of parallel input (second from MSB)
                    $display("Bit 1 = %b", d[1]);
                    dout <= {dout, d[1]};
                end
                3'b010: begin // Output third bit of parallel input (third from MSB)
                    $display("Bit 2 = %b", d[2]);
                    dout <= {dout, d[2]};
                end
                3'b011: begin // Output fourth and final bit of parallel input (LSB)
                    $display("LSB = %b", d[3]);
                    dout <= {dout, d[3]};
                end
            endcase
        end

endmodule