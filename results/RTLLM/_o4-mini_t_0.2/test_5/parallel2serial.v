module parallel2serial(
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    // internal shift‐register
    reg [3:0] data;
    // 2‐bit counter cycles 0→1→2→3→0…
    reg [1:0] cnt;
    // valid pulse (high only on MSB‐output cycle)
    reg       valid;

    // synchronous logic, reset active low
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data  <= 4'b0000;
            cnt   <= 2'b00;
            valid <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // last bit of previous word was just sent;
                // load new parallel word and output its MSB next
                data  <= d;
                cnt   <= 2'b00;
                valid <= 1'b1;
            end else begin
                // shift the register one bit left,
                // with MSB wrapping around into LSB
                data  <= {data[2:0], data[3]};
                cnt   <= cnt + 1'b1;
                valid <= 1'b0;
            end
        end
    end

    // serial out is always the MSB of 'data'
    assign dout      = data[3];
    // valid_out pulses high the cycle we output the freshly loaded MSB
    assign valid_out = valid;

endmodule