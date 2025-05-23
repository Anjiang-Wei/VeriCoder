module multi_pipe_8bit #(
    parameter size = 8
)(
    input                    clk,         // clock
    input                    rst_n,       // active‐low reset
    input                    mul_en_in,   // input enable
    input  [size-1:0]        mul_a,       // multiplicand
    input  [size-1:0]        mul_b,       // multiplier
    output reg               mul_en_out,  // output enable
    output reg [2*size-1:0]  mul_out      // 16‐bit product
);

    // Stage 1 registers: capture inputs
    reg [size-1:0]       mul_a_reg1, mul_b_reg1;
    reg                   en1;
    
    // Partial‐product wires
    wire [2*size-1:0]    temp [0:size-1];
    
    // Generate partial products (a << i) if b[i] is 1
    genvar i;
    generate
      for (i = 0; i < size; i = i + 1) begin : GEN_TEMP
        // Extend mul_a to 2*size bits before shift
        wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a_reg1};
        assign temp[i] = mul_b_reg1[i] ? (a_ext << i) : {2*size{1'b0}};
      end
    endgenerate

    // Stage 2 registers: sum pairs of partial products
    reg [2*size-1:0]    sum0_reg, sum1_reg, sum2_reg, sum3_reg;
    reg                   en2;

    // Stage 3 registers: sum of sums
    reg [2*size-1:0]    sum01_reg, sum23_reg;
    reg                   en3;

    // Stage 4 registers: final product
    reg [2*size-1:0]    mul_out_reg;
    reg                   en4;


    // ------------------------------------------------------------------------
    // Stage 1: latch inputs
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        mul_a_reg1 <= 0;
        mul_b_reg1 <= 0;
        en1        <= 0;
      end else begin
        mul_a_reg1 <= mul_a;
        mul_b_reg1 <= mul_b;
        en1        <= mul_en_in;
      end
    end


    // ------------------------------------------------------------------------
    // Stage 2: compute sums of partial product pairs
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        sum0_reg <= 0;
        sum1_reg <= 0;
        sum2_reg <= 0;
        sum3_reg <= 0;
        en2      <= 0;
      end else begin
        sum0_reg <= temp[0] + temp[1];
        sum1_reg <= temp[2] + temp[3];
        sum2_reg <= temp[4] + temp[5];
        sum3_reg <= temp[6] + temp[7];
        en2      <= en1;
      end
    end


    // ------------------------------------------------------------------------
    // Stage 3: sum the intermediate sums
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        sum01_reg <= 0;
        sum23_reg <= 0;
        en3       <= 0;
      end else begin
        sum01_reg <= sum0_reg + sum1_reg;
        sum23_reg <= sum2_reg + sum3_reg;
        en3       <= en2;
      end
    end


    // ------------------------------------------------------------------------
    // Stage 4: final addition to get the product
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        mul_out_reg <= 0;
        en4         <= 0;
      end else begin
        mul_out_reg <= sum01_reg + sum23_reg;
        en4         <= en3;
      end
    end


    // ------------------------------------------------------------------------
    // Output registers: present the result when valid
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        mul_en_out <= 0;
        mul_out    <= 0;
      end else begin
        mul_en_out <= en4;
        mul_out    <= en4 ? mul_out_reg : {2*size{1'b0}};
      end
    end

endmodule