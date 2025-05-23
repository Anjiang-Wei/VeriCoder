module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    // Internal signals
    wire [64:0] carry;

    // Generate 64 full adders
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : full_adder
            full_adder_64bit full_adder_inst (
                .a(adda[i]),
                .b(addb[i]),
                .cin(carry[i]),
                .sum(result[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // Set output enable when input enable is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 0;
        end else if (i_en) begin
            o_en <= 1;
        end
    end

endmodule