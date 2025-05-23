module parallel2serial(
    input         clk,    // clock input
    input         rst_n,  // asynchronous active‐low reset
    input  [3:0]  d,      // 4-bit parallel input
    output        valid_out, // valid signal for serial output
    output        dout      // serial data output
);

    // Internal registers
    reg [3:0] data;   // shift register that holds the 4-bit data
    reg [1:0] cnt;    // 2-bit counter since there are 4 states: 0,1,2,3
    reg       valid;  // internal valid flag

    // Sequential logic: on every clock cycle update counter, data and valid signal
    // Asynchronous reset: when rst_n is low, initialize registers.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt   <= 2'b00;
            data  <= 4'b0000;
            valid <= 1'b0;
        end else begin
            // When counter reaches 3, the next cycle will load new parallel data.
            // The MSB (data[3]) is output with valid=1 indicating new valid serial output.
            if (cnt == 2'b11) begin
                data  <= d;      // load new parallel input into data register
                cnt   <= 2'b00;  // reset the counter to 0
                valid <= 1'b1;   // set valid signal for this cycle (MSB output)
            end else begin
                // Otherwise, shift the data register left and wrap-around the MSB.
                // Also increment the counter and clear the valid flag.
                cnt   <= cnt + 1'b1;
                valid <= 1'b0;
                data  <= {data[2:0], data[3]}; // left-rotate: MSB becomes LSB
            end
        end
    end

    // Assign output signals.
    // dout always reflects the MSB (bit 3) of the data register.
    assign dout = data[3];
    assign valid_out = valid;

endmodule