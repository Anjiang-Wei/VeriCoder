module right_shifter(
    input clk,
    input reset,
    input d,
    output [7:0] q
);

    reg [7:0] q_reg;

    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= {q_reg[6:0], d};
        end
    end

    assign q = q_reg;

endmodule