module parallel2serial(
    input        clk,
    input        rst_n,   // active low reset
    input  [3:0] d,       // parallel 4‐bit input
    output       valid_out, // high when the MSB of new data is available
    output       dout      // serial output (MSB of current data register)
);

    // internal registers:
    // data holds the bits to be shifted out. Its MSB (bit 3) is output.
    reg [3:0] data;
    // counter counts how many shifts have occurred (0,1,2,3)
    reg [1:0] cnt;
    // valid_out is generated as a registered signal.
    reg       valid_reg;

    // continuous assignment: output dout is the current MSB of the data register.
    assign dout = data[3];
    // drive valid_out from our internal register.
    assign valid_out = valid_reg;

    // On reset (active low), we initialize the registers.
    // Notice: We want to load new parallel input immediately.
    // So initializing cnt to 3 forces the first cycle to load the data input.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd3;
            data      <= 4'b0;
            valid_reg <= 1'b0;
        end else begin
            // When counter reaches 3, load new parallel data.
            if (cnt == 2'd3) begin
                // load new data from input 'd'.
                data      <= d;
                // reset counter to 0 (starting a fresh conversion of 4 bits)
                cnt       <= 2'd0;
                // valid signal high indicates that the MSB of d is available.
                valid_reg <= 1'b1;
            end else begin
                // Otherwise, output the remaining 3 bits sequentially:
                // increment the counter by 1...
                cnt       <= cnt + 1;
                // ... and shift the data register to the left in a circular fashion.
                // The MSB shifts into the LSB position.
                data      <= {data[2:0], data[3]};
                // valid signal is low for these cycles (only high when newly loaded)
                valid_reg <= 1'b0;
            end
        end
    end

endmodule