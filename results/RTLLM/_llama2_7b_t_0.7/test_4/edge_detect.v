module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
) {
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 0;
            down <= 0;
        end else if (a == 1 && prev_a != 1) begin
            rise <= 1;
            down <= 1;
        end else begin
            rise <= 0;
            down <= 0;
        end
    end
}