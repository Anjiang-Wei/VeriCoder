module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);
    reg [3:0] data;
    reg [1:0] cnt;
    reg valid;
    wire [3:0] dout_wire;

    // Assign the most significant bit of the parallel input to the serial output
    assign dout = dout_wire[3];
    assign dout_wire = data;

    // Always block for synchronous operations on the clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state when reset is active
            data <= 4'b0000;
            cnt <= 2'b00;
            valid <= 1'b0;
        end else begin
            // Update the data register and counter on each clock cycle
            if (cnt == 2'b11) begin
                // When last bit is output, update data and reset counter
                data <= d;
                cnt <= 2'b00;
                valid <= 1'b1;
            end else begin
                // Shift data register and increment counter
                data <= {data[2:0], data[3]};
                cnt <= cnt + 1'b1;
                valid <= 1'b0;
            end
        end
    end

    // Assign valid signal to output
    assign valid_out = valid;

endmodule