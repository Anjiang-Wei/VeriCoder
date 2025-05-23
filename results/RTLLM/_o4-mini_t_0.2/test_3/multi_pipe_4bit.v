module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [2*size-1:0]    mul_out
);

    // total width of partial products and sums
    localparam N = 2*size;

    // extend multiplicand to N bits by adding 'size' zeros at MSB
    wire [N-1:0] a_ext = {{size{1'b0}}, mul_a};

    // generate partial products for each bit of mul_b
    wire [N-1:0] pp [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : PP_GEN
            assign pp[i] = mul_b[i] 
                           ? (a_ext << i)       // shift left by i
                           : {N{1'b0}};         // zero
        end
    endgenerate

    // Level‑1 registers: sum partial products in two groups
    reg [N-1:0] sum_stage1_lo;   // sum of pp[0] + pp[1]
    reg [N-1:0] sum_stage1_hi;   // sum of pp[2] + pp[3]

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_lo <= {N{1'b0}};
            sum_stage1_hi <= {N{1'b0}};
        end else begin
            sum_stage1_lo <= pp[0] + pp[1];
            sum_stage1_hi <= pp[2] + pp[3];
        end
    end

    // Level‑2 register: final accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {N{1'b0}};
        end else begin
            mul_out <= sum_stage1_lo + sum_stage1_hi;
        end
    end

endmodule