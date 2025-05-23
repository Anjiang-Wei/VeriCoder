module multi_pipe_8bit #(
    parameter size = 8
) (
    input                  clk,
    input                  rst_n,
    input                  mul_en_in,
    input  [size-1:0]      mul_a,
    input  [size-1:0]      mul_b,
    output reg             mul_en_out,
    output reg [size*2-1:0] mul_out
);

    // Pipeline enable signals
    reg [5:0] en_pipe;

    // Stage 0 registers: inputs
    reg [size-1:0] a_reg0;
    reg [size-1:0] b_reg0;

    // Stage 1 registers: partial products
    reg [size*2-1:0] pp_reg0;
    reg [size*2-1:0] pp_reg1;
    reg [size*2-1:0] pp_reg2;
    reg [size*2-1:0] pp_reg3;
    reg [size*2-1:0] pp_reg4;
    reg [size*2-1:0] pp_reg5;
    reg [size*2-1:0] pp_reg6;
    reg [size*2-1:0] pp_reg7;

    // Stage 2 registers: first-level sums
    reg [size*2-1:0] s1_reg0;
    reg [size*2-1:0] s1_reg1;
    reg [size*2-1:0] s1_reg2;
    reg [size*2-1:0] s1_reg3;

    // Stage 3 registers: second-level sums
    reg [size*2-1:0] s2_reg0;
    reg [size*2-1:0] s2_reg1;

    // Stage 4 register: final product
    reg [size*2-1:0] mul_out_reg;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset pipeline enables
            en_pipe  <= 6'b0;
            mul_en_out <= 1'b0;
            // reset stage registers
            a_reg0   <= {size{1'b0}};
            b_reg0   <= {size{1'b0}};
            pp_reg0  <= {(size*2){1'b0}};
            pp_reg1  <= {(size*2){1'b0}};
            pp_reg2  <= {(size*2){1'b0}};
            pp_reg3  <= {(size*2){1'b0}};
            pp_reg4  <= {(size*2){1'b0}};
            pp_reg5  <= {(size*2){1'b0}};
            pp_reg6  <= {(size*2){1'b0}};
            pp_reg7  <= {(size*2){1'b0}};
            s1_reg0  <= {(size*2){1'b0}};
            s1_reg1  <= {(size*2){1'b0}};
            s1_reg2  <= {(size*2){1'b0}};
            s1_reg3  <= {(size*2){1'b0}};
            s2_reg0  <= {(size*2){1'b0}};
            s2_reg1  <= {(size*2){1'b0}};
            mul_out_reg <= {(size*2){1'b0}};
            mul_out  <= {(size*2){1'b0}};
        end else begin
            // propagate enable through pipeline
            en_pipe[0] <= mul_en_in;
            for (i = 1; i < 6; i = i + 1)
                en_pipe[i] <= en_pipe[i-1];
            mul_en_out <= en_pipe[5];

            // Stage 0: latch inputs when enable is high
            if (mul_en_in) begin
                a_reg0 <= mul_a;
                b_reg0 <= mul_b;
            end

            // Stage 1: generate and register partial products
            pp_reg0 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[0]}} }) << 0 : 0;
            pp_reg1 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[1]}} }) << 1 : 0;
            pp_reg2 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[2]}} }) << 2 : 0;
            pp_reg3 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[3]}} }) << 3 : 0;
            pp_reg4 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[4]}} }) << 4 : 0;
            pp_reg5 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[5]}} }) << 5 : 0;
            pp_reg6 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[6]}} }) << 6 : 0;
            pp_reg7 <= en_pipe[0] ? ({{size{1'b0}}, a_reg0}       & { {(size*2-size){1'b1}}, {size{b_reg0[7]}} }) << 7 : 0;

            // Stage 2: first-level sums
            s1_reg0 <= en_pipe[1] ? (pp_reg0 + pp_reg1) : 0;
            s1_reg1 <= en_pipe[1] ? (pp_reg2 + pp_reg3) : 0;
            s1_reg2 <= en_pipe[1] ? (pp_reg4 + pp_reg5) : 0;
            s1_reg3 <= en_pipe[1] ? (pp_reg6 + pp_reg7) : 0;

            // Stage 3: second-level sums
            s2_reg0 <= en_pipe[2] ? (s1_reg0 + s1_reg1) : 0;
            s2_reg1 <= en_pipe[2] ? (s1_reg2 + s1_reg3) : 0;

            // Stage 4: final product
            mul_out_reg <= en_pipe[3] ? (s2_reg0 + s2_reg1) : 0;

            // Stage 5: assign output or zero
            mul_out <= en_pipe[4] ? mul_out_reg : {(size*2){1'b0}};
        end
    end

endmodule