module top_module (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] c
);

reg [7:0] temp;

always @(posedge clk) begin
    if (reset) begin
        temp <= 8'b0;
        c <= 8'b0;
    end else begin
        temp <= a + b;
        c <= temp;
    end
end

endmodule