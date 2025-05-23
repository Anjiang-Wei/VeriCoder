module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    // internal accumulator and counter
    reg [9:0]   sum_reg;
    reg [1:0]   cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // asynchronous reset
            sum_reg   <= 10'd0;
            cnt       <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            // default: no output this cycle
            valid_out <= 1'b0;

            if (valid_in) begin
                if (cnt == 2'd3) begin
                    // this is the 4th valid input: produce result
                    data_out  <= sum_reg + data_in;
                    valid_out <= 1'b1;
                    // reset for next accumulation
                    sum_reg   <= 10'd0;
                    cnt       <= 2'd0;
                end else begin
                    // accumulate and increment count
                    sum_reg <= sum_reg + data_in;
                    cnt     <= cnt + 1'b1;
                end
            end
        end
    end

endmodule