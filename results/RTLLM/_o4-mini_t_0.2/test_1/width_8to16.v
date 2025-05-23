module width_8to16(
    input              clk,
    input              rst_n,
    input              valid_in,
    input       [7:0]  data_in,
    output reg         valid_out,
    output reg [15:0]  data_out
);

    // internal storage for the first byte
    reg [7:0] data_lock;
    // flag = 1 when data_lock holds a pending first byte
    reg       flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset all state
            data_lock <= 8'b0;
            flag       <= 1'b0;
            valid_out  <= 1'b0;
            data_out   <= 16'b0;
        end else begin
            // default: deassert valid_out unless we complete a pair this cycle
            valid_out <= 1'b0;

            if (valid_in) begin
                if (!flag) begin
                    // first byte arrives: store it
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // second byte arrives: emit concatenation
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    flag      <= 1'b0;
                end
            end
        end
    end

endmodule