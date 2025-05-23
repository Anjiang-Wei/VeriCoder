module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
);

reg [31:0] c;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 32'b0;
    end else begin
        // Perform the multiplication
        wire [63:0] product = a * b;
        
        // Check for overflow
        if (product[63] && (product[31:0] !== 32'b0)) begin
            // Overflow occurred, set the result to the maximum 32-bit value
            c <= 32'h7FFFFFFF;
        end else if (~product[63] && (product[31:0] !== 32'hFFFFFFFF)) begin
            // Overflow occurred, set the result to the minimum 32-bit value
            c <= 32'h80000000;
        end else begin
            // No overflow, accumulate the result
            c <= c + product[31:0];
        end
    end
end

endmodule