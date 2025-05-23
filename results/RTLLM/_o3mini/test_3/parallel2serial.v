module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

    // Internal registers:
    reg [3:0] data;   // Holds the 4-bit data to be serialized
    reg [1:0] cnt;    // 2-bit counter to count from 0 to 3
    reg valid;        // Internal valid signal

    // The serial output is the MSB of the data register.
    assign dout = data[3];
    assign valid_out = valid;

    // On reset (active low) initialize registers.
    // On every positive clock edge, if the counter equals 3, then load new 
    // parallel input d into data, reset cnt to 0, and assert valid.
    // Otherwise, increment cnt, de-assert valid, and perform a circular left shift.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt   <= 2'd0;
            data  <= 4'd0;
            valid <= 1'b0;
        end
        else begin
            if (cnt == 2'd3) begin
                cnt   <= 2'd0;
                data  <= d;         // Reload data register with parallel input
                valid <= 1'b1;      // Valid output for the new MSB (d[3])
            end
            else begin
                cnt   <= cnt + 1;
                valid <= 1'b0;
                // Circular shift left: shift data left and reinsert the MSB at LSB
                data <= {data[2:0], data[3]};
            end
        end
    end

endmodule