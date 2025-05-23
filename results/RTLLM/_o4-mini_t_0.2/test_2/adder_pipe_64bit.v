module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)
(
    input                          clk,
    input                          rst_n,
    input                          i_en,
    input  [DATA_WIDTH-1:0]        adda,
    input  [DATA_WIDTH-1:0]        addb,
    output [DATA_WIDTH:0]          result,
    output reg                     o_en
);

    // number of STAGES
    localparam STG_NUM = DATA_WIDTH / STG_WIDTH;  // = 4

    // pipeline registers
    reg  [DATA_WIDTH-1:0] a_pipe   [0:STG_NUM];
    reg  [DATA_WIDTH-1:0] b_pipe   [0:STG_NUM];
    reg  [STG_WIDTH-1:0]  sum_pipe [1:STG_NUM];
    reg                   carry_pipe [0:STG_NUM];
    reg                   en_pipe    [0:STG_NUM];

    integer idx;

    // Main pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset all pipeline registers
            for (idx = 0; idx <= STG_NUM; idx = idx + 1) begin
                a_pipe[idx]     <= {DATA_WIDTH{1'b0}};
                b_pipe[idx]     <= {DATA_WIDTH{1'b0}};
                carry_pipe[idx] <= 1'b0;
                en_pipe[idx]    <= 1'b0;
            end
            for (idx = 1; idx <= STG_NUM; idx = idx + 1) begin
                sum_pipe[idx] <= {STG_WIDTH{1'b0}};
            end
            o_en <= 1'b0;
        end else begin
            // Stage 0 load
            a_pipe[0]     <= adda;
            b_pipe[0]     <= addb;
            carry_pipe[0] <= 1'b0;    // no incoming carry at stage 0
            en_pipe[0]    <= i_en;

            // subsequent stages
            for (idx = 1; idx <= STG_NUM; idx = idx + 1) begin
                // propagate operands & enable
                a_pipe[idx]  <= a_pipe[idx-1];
                b_pipe[idx]  <= b_pipe[idx-1];
                en_pipe[idx] <= en_pipe[idx-1];

                // perform the 16‐bit add + carry
                // { next_carry, sum_pipe } = a_segment + b_segment + carry_in
                { carry_pipe[idx],
                  sum_pipe[idx] }
                  <= {1'b0, a_pipe[idx-1][ idx*STG_WIDTH-1 : (idx-1)*STG_WIDTH ]}
                   + {1'b0, b_pipe[idx-1][ idx*STG_WIDTH-1 : (idx-1)*STG_WIDTH ]}
                   + carry_pipe[idx-1];
            end

            // update output enable when final stage is valid
            o_en <= en_pipe[STG_NUM];
        end
    end

    // collect the partial sums & final carry into the 65‐bit result
    // result[64] = carry out of last stage
    assign result[DATA_WIDTH] = carry_pipe[STG_NUM];

    // result[15:0]   = sum_pipe[1]
    // result[31:16]  = sum_pipe[2]
    // result[47:32]  = sum_pipe[3]
    // result[63:48]  = sum_pipe[4]
    genvar gv;
    generate
      for (gv = 0; gv < STG_NUM; gv = gv + 1) begin : GEN_SUM
        assign result[ gv*STG_WIDTH +: STG_WIDTH ] = sum_pipe[gv+1];
      end
    endgenerate

endmodule