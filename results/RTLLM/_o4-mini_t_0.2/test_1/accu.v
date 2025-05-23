module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,

    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    // internal accumulator and sample count
    reg [9:0] sum_reg;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // asynchronous reset
            sum_reg    <= 10'd0;
            cnt        <= 2'd0;
            data_out   <= 10'd0;
            valid_out  <= 1'b0;
        end else begin
            // default: no output unless we just finished 4 samples
            valid_out <= 1'b0;

            if (valid_in) begin
                if (cnt == 2'd3) begin
                    // This is the 4th valid sample:
                    // form output = sum of the previous 3 + this one
                    data_out  <= sum_reg + data_in;
                    valid_out <= 1'b1;
                    // reset accumulator/counter for next group
                    sum_reg   <= 10'd0;
                    cnt       <= 2'd0;
                end else begin
                    // still accumulating first 1..3 samples
                    sum_reg <= sum_reg + data_in;
                    cnt     <= cnt + 1'b1;
                end
            end
        end
    end

endmodule