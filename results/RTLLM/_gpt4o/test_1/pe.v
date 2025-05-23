module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);

    // Register to hold the accumulated result (partial sum)
    reg [31:0] c_reg;

    // Assign the register value to the output "c"
    assign c = c_reg;

    // Always block for synchronous operations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // On reset, clear the accumulated result
            c_reg <= 32'b0;
        end else begin
            // Multiply `a` and `b`, and accumulate the result in `c_reg`
            c_reg <= c_reg + (a * b);
        end
    end

endmodule