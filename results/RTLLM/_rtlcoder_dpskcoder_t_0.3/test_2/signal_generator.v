module top_module(
    input wire clk,
    input wire rst_n,
    input wire [7:0] in,
    output wire [7:0] out
);

    reg [7:0] reg_out;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg_out <= 8'b0;
        end else begin
            reg_out <= in;
        end
    end

    assign out = reg_out;

endmodule