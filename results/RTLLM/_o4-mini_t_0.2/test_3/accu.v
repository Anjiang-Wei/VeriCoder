module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    // Internal accumulation register and counter
    reg [9:0] sum_reg;
    reg [1:0] cnt;  // counts from 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset
            sum_reg   <= 10'd0;
            cnt       <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            // By default, no output this cycle
            valid_out <= 1'b0;

            if (valid_in) begin
                // We have a new valid byte in
                if (cnt == 2'd3) begin
                    // This is the 4th byte: form the final sum, pulse valid_out, and reset
                    data_out  <= sum_reg + data_in;
                    valid_out <= 1'b1;
                    sum_reg   <= 10'd0;
                    cnt       <= 2'd0;
                end else begin
                    // Accumulate and increment count
                    sum_reg <= sum_reg + data_in;
                    cnt     <= cnt + 1'b1;
                end
            end
        end
    end

endmodule