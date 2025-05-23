module parallel2serial(
    input clk,         // Clock signal used for synchronous operations.
    input rst_n,       // Reset signal. Defined as 0 for reset and 1 for reset signal inactive.
    input [3:0] d,     // 4-bit parallel data input.

    output valid_out,  // Valid signal indicating the availability of serial output.
    output dout        // Serial output representing the converted data.
);

reg [3:0] cnt;       // Counter register to track the current bit position.
reg [3:0] data;      // Data register to store the parallel input during serialization.

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)     // Asynchronous reset. Reset the counter and data register on active-low reset signal.
        cnt <= 4'd1;
    else
    begin
        if (cnt == 3)  // Update valid signal when the last bit is processed.
            valid_out <= 1'b1;

        case (cnt)
            4'b0000: // No action. Counter not incremented yet.
                valid_out <= 1'b0;
                data <= d;     // Load parallel input into the data register for serialization.
            default:
                begin
                    cnt <= cnt + 1'd1;    // Increment counter by one.
                    data <= {data[2], data[3], data[1], data[0]}; // Shift data left, MSB to LSB.
                end
        endcase

        if (cnt == 4'b1000)     // Counter overflow. Reset it and update valid signal.
            begin
                cnt <= 4'b0000;
                valid_out <= 1'b0;       // Valid signal is no longer asserted after serialization.
            end

        case (valid_out)
            1'b0: dout <= data[3];     // Output the most significant bit when valid signal is low.
            default:
                begin
                    if (cnt == 4'b1000)   // Output remaining bits sequentially.
                        begin
                            dout <= data;
                            cnt <= 4'b0000; // Counter reset after serialization.
                        end
                    else
                        dout <= {data[2], data[3]}; // MSB at least significant position, followed by next bit.
                end
        endcase
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)     // Asynchronous reset. Reset the counter and data register on active-low reset signal.
        cnt <= 4'd1;
    else
        if (cnt != 4'b1000)    // Increment counter only when not at last position in serialization.
            cnt <= cnt + 1'd1;   // Increment counter by one during synchronization.
end

endmodule