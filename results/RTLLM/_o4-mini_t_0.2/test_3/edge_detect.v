module edge_detect(
    input        clk,
    input        rst_n,
    input        a,
    output reg   rise,
    output reg   down
);

    // register to hold the delayed version of 'a'
    reg a_d;

    // detect edges on the rising edge of clk, with active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d   <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // rising edge: a goes from 0 to 1
            rise  <= (~a_d) &  a;
            // falling edge: a goes from 1 to 0
            down  <=  a_d  & (~a);
            // update delayed version of a
            a_d   <= a;
        end
    end

endmodule