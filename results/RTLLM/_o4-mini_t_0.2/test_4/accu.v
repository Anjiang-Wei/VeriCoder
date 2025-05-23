module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    
    output  reg         valid_out,
    output  reg [9:0]   data_out
);

    // internal counter and accumulator
    reg [1:0] cnt;       // counts valid inputs (0 to 3)
    reg [9:0] sum;       // accumulates up to four 8-bit values (max 1020)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            sum       <= 10'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            // default: no output unless we finish 4 inputs this cycle
            valid_out <= 1'b0;

            if (valid_in) begin
                if (cnt == 2'd3) begin
                    // this is the fourth valid input
                    data_out  <= sum + data_in;  // final sum of four inputs
                    valid_out <= 1'b1;
                    sum       <= 10'd0;          // reset accumulator
                    cnt       <= 2'd0;           // reset counter
                end else begin
                    // accumulate and increment counter
                    sum <= sum + data_in;
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule