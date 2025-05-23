module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input  [size-1:0]           mul_a,
    input  [size-1:0]           mul_b,
    output reg [2*size-1:0]     mul_out
);

    // total product width
    localparam N = 2*size;

    // extend multiplicand to N bits
    wire [N-1:0] a_ext = {{size{1'b0}}, mul_a};

    // generate partial products pp[0..size-1], each N bits
    wire [N-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PP
            assign pp[i] = mul_b[i] 
                           ? (a_ext << i)    // shift by bit index
                           : {N{1'b0}};      // else zero
        end
    endgenerate

    // pipeline registers stage 1: sum pairs of partial products
    reg [N-1:0] sum01_reg, sum23_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg <= {N{1'b0}};
            sum23_reg <= {N{1'b0}};
        end else begin
            // for size=4 we hardcode pair sums:
            sum01_reg <= pp[0] + pp[1];
            sum23_reg <= pp[2] + pp[3];
        end
    end

    // pipeline stage 2: final sum -> output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {N{1'b0}};
        end else begin
            mul_out <= sum01_reg + sum23_reg;
        end
    end

endmodule