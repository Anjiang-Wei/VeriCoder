module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    // counter for number of received samples (0..3)
    reg [1:0] cnt;
    // accumulator for incoming data
    reg [9:0] acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            acc       <= 10'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            // default: no output this cycle
            valid_out <= 1'b0;

            if (valid_in) begin
                if (cnt == 2'd3) begin
                    // this is the 4th valid sample: finalize sum
                    data_out  <= acc + data_in;
                    valid_out <= 1'b1;
                    // reset for next group
                    acc <= 10'd0;
                    cnt <= 2'd0;
                end else begin
                    // accumulate and increment count
                    acc <= acc + data_in;
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule