module edge_detect(
    input        clk,
    input        rst_n,
    input        a,
    output reg   rise,
    output reg   down
);

    // delayed version of 'a' to detect edges
    reg a_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d   <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // detect rising edge: a goes 0→1
            rise <= (~a_d) & a;
            // detect falling edge: a goes 1→0
            down <= a_d & (~a);
            // update delayed version of 'a'
            a_d  <= a;
        end
    end

endmodule