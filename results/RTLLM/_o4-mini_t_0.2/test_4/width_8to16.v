module width_8to16(
    input            clk      ,  // clock
    input            rst_n    ,  // active low reset
    input            valid_in ,  // input data valid
    input  [7:0]     data_in  ,  // 8‑bit input data
    output reg       valid_out,  // output data valid
    output reg [15:0] data_out   // 16‑bit output data
);

    // buffer to hold the first byte
    reg [7:0] data_lock;
    // flag: 1 when we have stored the first byte, waiting for the second
    reg       have_one;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // asynchronous reset
            data_lock  <= 8'd0;
            have_one   <= 1'b0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end else begin
            // default: until we see the second byte, valid_out is low
            valid_out <= 1'b0;

            if (valid_in) begin
                if (!have_one) begin
                    // first valid byte arrives: store it
                    data_lock <= data_in;
                    have_one  <= 1'b1;
                end else begin
                    // second valid byte arrives: concatenate & emit
                    data_out  <= { data_lock, data_in };
                    valid_out <= 1'b1;
                    have_one  <= 1'b0;
                end
            end
            // if valid_in==0, do nothing (hold state until next valid_in)
        end
    end

endmodule