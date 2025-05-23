module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output reg [31:0] c
);

    // Always block that updates the accumulated result on clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the accumulator to 0
            c <= 32'b0;
        end else begin
            // Perform multiplication and accumulation
            c <= c + (a * b);
        end
    end

endmodule