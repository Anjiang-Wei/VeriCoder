module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)
(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input  [DATA_WIDTH-1:0]     adda,
    input  [DATA_WIDTH-1:0]     addb,
    output [DATA_WIDTH:0]       result,
    output reg                  o_en
);

    // Number of stages
    localparam STG_COUNT = DATA_WIDTH / STG_WIDTH;  // = 4 for 64/16

    // Pipeline registers: operands, partial sums, carries and enables
    reg  [STG_WIDTH-1:0] a_reg [0:STG_COUNT-1];
    reg  [STG_WIDTH-1:0] b_reg [0:STG_COUNT-1];
    reg                  c_reg [0:STG_COUNT];      // carry_in for stage[0]..carry_out at stage[4]
    reg                  en_reg[0:STG_COUNT];      // valid flags
    reg  [STG_WIDTH-1:0] s_reg [0:STG_COUNT-1];    // partial sums

    // Combinational partial sums + carry_out
    wire [STG_WIDTH:0] sum_w [0:STG_COUNT-1];
    genvar i;
    generate
      for(i = 0; i < STG_COUNT; i = i + 1) begin : GEN_SUM
        assign sum_w[i] = a_reg[i] + b_reg[i] + c_reg[i];
      end
    endgenerate

    // Pipeline logic
    integer stage;
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        // reset all pipeline registers
        for(stage = 0; stage <= STG_COUNT; stage = stage + 1) begin
          if (stage < STG_COUNT) begin
            a_reg[stage] <= {STG_WIDTH{1'b0}};
            b_reg[stage] <= {STG_WIDTH{1'b0}};
            s_reg[stage] <= {STG_WIDTH{1'b0}};
          end
          c_reg[stage] <= 1'b0;
          en_reg[stage] <= 1'b0;
        end
        o_en <= 1'b0;
      end else begin
        // Stage 0: latch inputs, carry_in=0
        en_reg[0]   <= i_en;
        a_reg[0]    <= adda[ STG_WIDTH-1              :  0];
        b_reg[0]    <= addb[ STG_WIDTH-1              :  0];
        c_reg[0]    <= 1'b0;
        // compute and register stage0 outputs
        s_reg[0]    <= sum_w[0][STG_WIDTH-1:0];
        c_reg[1]    <= sum_w[0][STG_WIDTH];
        en_reg[1]   <= en_reg[0];

        // Stage 1
        a_reg[1]    <= adda[ 2*STG_WIDTH-1           :  STG_WIDTH];
        b_reg[1]    <= addb[ 2*STG_WIDTH-1           :  STG_WIDTH];
        s_reg[1]    <= sum_w[1][STG_WIDTH-1:0];
        c_reg[2]    <= sum_w[1][STG_WIDTH];
        en_reg[2]   <= en_reg[1];

        // Stage 2
        a_reg[2]    <= adda[ 3*STG_WIDTH-1           : 2*STG_WIDTH];
        b_reg[2]    <= addb[ 3*STG_WIDTH-1           : 2*STG_WIDTH];
        s_reg[2]    <= sum_w[2][STG_WIDTH-1:0];
        c_reg[3]    <= sum_w[2][STG_WIDTH];
        en_reg[3]   <= en_reg[2];

        // Stage 3 (MSBs)
        a_reg[3]    <= adda[ 4*STG_WIDTH-1           : 3*STG_WIDTH];
        b_reg[3]    <= addb[ 4*STG_WIDTH-1           : 3*STG_WIDTH];
        s_reg[3]    <= sum_w[3][STG_WIDTH-1:0];
        c_reg[4]    <= sum_w[3][STG_WIDTH];
        en_reg[4]   <= en_reg[3];

        // Final output enable and result
        o_en        <= en_reg[4];
      end
    end

    // Assemble the 65‑bit result from the 4 partial sums + final carry
    assign result = {
      c_reg[4],
      s_reg[3],
      s_reg[2],
      s_reg[1],
      s_reg[0]
    };

endmodule