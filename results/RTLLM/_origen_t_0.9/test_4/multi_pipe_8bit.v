Please implement the missing parts of the Verilog code:
```verilog
  // Input Control
  reg mul_en_out_reg;
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      mul_en_out_reg <= 0;
    else
      mul_en_out_reg <= mul_en_in;
  end
  assign mul_en_out = mul_en_out_reg[3];

  // Input Registers
  reg [size-1:0] mul_a_reg, mul_b_reg;
  always @(posedge clk) begin
    if(mul_en_out_reg[2]) begin
      mul_a_reg <= mul_a;
      mul_b_reg <= mul_b;
    end
  end

  // Partial Product Generation
  wire [size-1:0] temp[0:size-1];
  genvar i;
  generate
    for(i=0; i<size; i=i+1) begin : gen_temp
      assign temp[i] = {size{mul_b_reg[i]}} & mul_a_reg;
    end
  endgenerate

  // Partial Sum Calculation
  reg [size-1:0] sum[0:size-1];
  genvar j;
  generate
    for(j=0; j<size; j=j+1) begin : gen_sum
      if(j==0)
        always @(posedge clk) begin
          if(mul_en_out_reg[2])
            sum[j] <= temp[0];
        end
      else
        always @(posedge clk) begin
          if(mul_en_out_reg[2])
            sum[j] <= sum[j-1] + temp[j];
        end
    end
  endgenerate

  // Final Product Calculation
  reg [size*2-1:0] mul_out_reg;
  always @(posedge clk) begin
    if(mul_en_out_reg[2])
      mul_out_reg <= {sum[size-1], sum[size-1]};
  end

  // Output Assignment
  always @(posedge clk) begin
    if(mul_en_out_reg[3])
      mul_out <= mul_out_reg;
    else
      mul_out <= 0;
  end
endmodule