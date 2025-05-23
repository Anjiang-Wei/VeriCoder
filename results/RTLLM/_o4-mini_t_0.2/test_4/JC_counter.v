module JC_counter(
    input            clk,
    input            rst_n,
    output reg [63:0] Q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;
        end else begin
            // If LSB is 0, shift right and insert a 1 at MSB
            if (Q[0] == 1'b0)
                Q <= {1'b1, Q[63:1]};
            else
                // If LSB is 1, shift right and insert a 0 at MSB
                Q <= {1'b0, Q[63:1]};
        end
    end

endmodule