module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
) {
    always @(*) begin
        if (a && !rise) begin
            rise <= 1;
            down <= 0;
        end else if (!a && rise) begin
            rise <= 0;
            down <= 1;
        end
    end
}