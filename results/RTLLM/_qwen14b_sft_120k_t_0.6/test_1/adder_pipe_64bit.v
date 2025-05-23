module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output reg o_en
);
    // Pipeline registers
    reg [DATA_WIDTH:0] sum0, sum1, sum2, sum3, sum4;
    reg [DATA_WIDTH:0] carry0, carry1, carry2, carry3, carry4;
    reg [DATA_WIDTH:0] en0, en1, en2, en3, en4;

    // Combinational logic for each pipeline stage
    always @(*) begin
        sum0 = {1'b0, adda} + {1'b0, addb};  // Initial sum
        carry0 = sum0[DATA_WIDTH]; // Carry from sum0
        sum1 = {1'b0, sum0[DATA_WIDTH-1:0]} + {1'b0, carry0}; // Sum with carry
        carry1 = sum1[DATA_WIDTH]; // Carry from sum1
        sum2 = {1'b0, sum1[DATA_WIDTH-1:0]} + {1'b0, carry1}; // Sum with carry
        carry2 = sum2[DATA_WIDTH]; // Carry from sum2
        sum3 = {1'b0, sum2[DATA_WIDTH-1:0]} + {1'b0, carry2}; // Sum with carry
        carry3 = sum3[DATA_WIDTH]; // Carry from sum3
        sum4 = {1'b0, sum3[DATA_WIDTH-1:0]} + {1'b0, carry3}; // Final sum
        carry4 = sum4[DATA_WIDTH]; // Carry from sum4
    end

    // Synchronizing pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en0 <= 0;
            en1 <= 0;
            en2 <= 0;
            en3 <= 0;
            en4 <= 0;
            sum0 <= 0;
            sum1 <= 0;
            sum2 <= 0;
            sum3 <= 0;
            sum4 <= 0;
            carry0 <= 0;
            carry1 <= 0;
            carry2 <= 0;
            carry3 <= 0;
            carry4 <= 0;
            o_en <= 0;
        end else begin
            en0 <= i_en; // Enable for first stage
            en1 <= en0;  // Propagate enable through stages
            en2 <= en1;
            en3 <= en2;
            en4 <= en3;
            sum0 <= sum0; // Latch sum for first stage
            sum1 <= sum1;
            sum2 <= sum2;
            sum3 <= sum3;
            sum4 <= sum4;
            carry0 <= carry0; // Latch carry for first stage
            carry1 <= carry1;
            carry2 <= carry2;
            carry3 <= carry3;
            carry4 <= carry4;
            o_en <= en4; // Output enable based on last stage
        end
    end

    // Assigning final sum to result
    assign result = sum4;

endmodule