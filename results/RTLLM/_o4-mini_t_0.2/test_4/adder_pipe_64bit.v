module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)
(
    input                     clk,
    input                     rst_n,
    input                     i_en,
    input  [DATA_WIDTH-1:0]   adda,
    input  [DATA_WIDTH-1:0]   addb,
    output [DATA_WIDTH:0]     result,
    output reg                o_en
);

    //-------------------------------------------------------------------------
    // Stage 0 registers: latch low 16 bits + enable
    //-------------------------------------------------------------------------
    reg  [STG_WIDTH-1:0] a0_reg, b0_reg;
    reg                  en0_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a0_reg  <= {STG_WIDTH{1'b0}};
            b0_reg  <= {STG_WIDTH{1'b0}};
            en0_reg <= 1'b0;
        end else begin
            if (i_en) begin
                a0_reg <= adda[STG_WIDTH-1:0];
                b0_reg <= addb[STG_WIDTH-1:0];
            end else begin
                a0_reg <= {STG_WIDTH{1'b0}};
                b0_reg <= {STG_WIDTH{1'b0}};
            end
            en0_reg <= i_en;
        end
    end

    wire [STG_WIDTH-1:0] sum0;
    wire                 carry0;
    assign {carry0, sum0} = {1'b0, a0_reg} + {1'b0, b0_reg};

    //-------------------------------------------------------------------------
    // Stage 1 registers: latch next 16 bits + carry + enable
    //-------------------------------------------------------------------------
    reg  [STG_WIDTH-1:0] a1_reg, b1_reg;
    reg                  c1_reg;
    reg                  en1_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a1_reg <= {STG_WIDTH{1'b0}};
            b1_reg <= {STG_WIDTH{1'b0}};
            c1_reg <= 1'b0;
            en1_reg<= 1'b0;
        end else begin
            a1_reg  <= adda[2*STG_WIDTH-1: STG_WIDTH];
            b1_reg  <= addb[2*STG_WIDTH-1: STG_WIDTH];
            c1_reg  <= carry0;
            en1_reg <= en0_reg;
        end
    end

    wire [STG_WIDTH-1:0] sum1;
    wire                 carry1;
    assign {carry1, sum1} = {c1_reg, a1_reg} + {1'b0, b1_reg};

    //-------------------------------------------------------------------------
    // Stage 2 registers: latch next 16 bits + carry + enable
    //-------------------------------------------------------------------------
    reg  [STG_WIDTH-1:0] a2_reg, b2_reg;
    reg                  c2_reg;
    reg                  en2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a2_reg <= {STG_WIDTH{1'b0}};
            b2_reg <= {STG_WIDTH{1'b0}};
            c2_reg <= 1'b0;
            en2_reg<= 1'b0;
        end else begin
            a2_reg  <= adda[3*STG_WIDTH-1: 2*STG_WIDTH];
            b2_reg  <= addb[3*STG_WIDTH-1: 2*STG_WIDTH];
            c2_reg  <= carry1;
            en2_reg <= en1_reg;
        end
    end

    wire [STG_WIDTH-1:0] sum2;
    wire                 carry2;
    assign {carry2, sum2} = {c2_reg, a2_reg} + {1'b0, b2_reg};

    //-------------------------------------------------------------------------
    // Stage 3 registers: latch top 16 bits + carry + enable
    //-------------------------------------------------------------------------
    reg  [STG_WIDTH-1:0] a3_reg, b3_reg;
    reg                  c3_reg;
    reg                  en3_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a3_reg <= {STG_WIDTH{1'b0}};
            b3_reg <= {STG_WIDTH{1'b0}};
            c3_reg <= 1'b0;
            en3_reg<= 1'b0;
        end else begin
            a3_reg  <= adda[4*STG_WIDTH-1: 3*STG_WIDTH];
            b3_reg  <= addb[4*STG_WIDTH-1: 3*STG_WIDTH];
            c3_reg  <= carry2;
            en3_reg <= en2_reg;
        end
    end

    wire [STG_WIDTH-1:0] sum3;
    wire                 carry3;
    assign {carry3, sum3} = {c3_reg, a3_reg} + {1'b0, b3_reg};

    //-------------------------------------------------------------------------
    // Final pipeline register: collect all partial sums + final carry + enable
    //-------------------------------------------------------------------------
    reg [STG_WIDTH-1:0] sum0_reg, sum1_reg, sum2_reg, sum3_reg;
    reg                 carry_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_reg     <= {STG_WIDTH{1'b0}};
            sum1_reg     <= {STG_WIDTH{1'b0}};
            sum2_reg     <= {STG_WIDTH{1'b0}};
            sum3_reg     <= {STG_WIDTH{1'b0}};
            carry_out_reg<= 1'b0;
            o_en         <= 1'b0;
        end else begin
            sum0_reg      <= sum0;
            sum1_reg      <= sum1;
            sum2_reg      <= sum2;
            sum3_reg      <= sum3;
            carry_out_reg <= carry3;
            o_en          <= en3_reg;
        end
    end

    // Concatenate the final 65‑bit result
    assign result = { carry_out_reg
                    , sum3_reg
                    , sum2_reg
                    , sum1_reg
                    , sum0_reg
                    };

endmodule