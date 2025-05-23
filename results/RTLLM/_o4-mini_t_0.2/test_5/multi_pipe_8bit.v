module multi_pipe_8bit #(
    parameter size = 8
)(
    input               clk,
    input               rst_n,       // active low
    input               mul_en_in,   // input enable
    input   [size-1:0]  mul_a,       // multiplicand
    input   [size-1:0]  mul_b,       // multiplier

    output              mul_en_out,  // output enable
    output  [size*2-1:0] mul_out     // 16‐bit product
);

    //----------------------------------------------------------------
    // Stage1 registers: capture inputs
    //----------------------------------------------------------------
    reg                 en_stage1;
    reg  [size-1:0]     a_stage1;
    reg  [size-1:0]     b_stage1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage1 <= 1'b0;
            a_stage1  <= {size{1'b0}};
            b_stage1  <= {size{1'b0}};
        end else begin
            en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                a_stage1 <= mul_a;
                b_stage1 <= mul_b;
            end
        end
    end

    //----------------------------------------------------------------
    // Stage2: partial products + first‐level pairwise addition
    //----------------------------------------------------------------
    wire [15:0] pp [7:0];
    genvar i;
    for (i = 0; i < size; i = i + 1) begin : GEN_PP
        // Generate partial product and shift by bit‐position
        assign pp[i] = b_stage1[i] 
                       ? {{(16-size){1'b0}}, a_stage1} << i 
                       : 16'h0000;
    end

    reg                 en_stage2;
    reg  [15:0]         sum01_stage2;
    reg  [15:0]         sum23_stage2;
    reg  [15:0]         sum45_stage2;
    reg  [15:0]         sum67_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage2    <= 1'b0;
            sum01_stage2 <= 16'd0;
            sum23_stage2 <= 16'd0;
            sum45_stage2 <= 16'd0;
            sum67_stage2 <= 16'd0;
        end else begin
            en_stage2 <= en_stage1;
            if (en_stage1) begin
                sum01_stage2 <= pp[0] + pp[1];
                sum23_stage2 <= pp[2] + pp[3];
                sum45_stage2 <= pp[4] + pp[5];
                sum67_stage2 <= pp[6] + pp[7];
            end
        end
    end

    //----------------------------------------------------------------
    // Stage3: second‐level pairwise addition
    //----------------------------------------------------------------
    reg                 en_stage3;
    reg  [15:0]         sum0123_stage3;
    reg  [15:0]         sum4567_stage3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage3       <= 1'b0;
            sum0123_stage3  <= 16'd0;
            sum4567_stage3  <= 16'd0;
        end else begin
            en_stage3 <= en_stage2;
            if (en_stage2) begin
                sum0123_stage3 <= sum01_stage2 + sum23_stage2;
                sum4567_stage3 <= sum45_stage2 + sum67_stage2;
            end
        end
    end

    //----------------------------------------------------------------
    // Stage4: final accumulation + output registers
    //----------------------------------------------------------------
    reg                 en_stage4;
    reg  [15:0]         product_stage4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage4        <= 1'b0;
            product_stage4  <= 16'd0;
        end else begin
            en_stage4 <= en_stage3;
            if (en_stage3) begin
                product_stage4 <= sum0123_stage3 + sum4567_stage3;
            end
        end
    end

    //----------------------------------------------------------------
    // Output assignments
    //----------------------------------------------------------------
    assign mul_en_out = en_stage4;
    assign mul_out    = en_stage4 ? product_stage4 : 16'd0;

endmodule