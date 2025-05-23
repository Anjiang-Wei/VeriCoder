module multi_pipe_8bit#(parameter size = 8)(
    input clk,
    input rst_n,
    input mul_en_in,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg mul_en_out,
    output reg [size*2-1:0] mul_out
);

  // Input Control Signals
  always #$etime(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      mul_en_out <= 0;
      mul_out <= 0;
    end else begin
      // Sample input enable signal and store in register
      if (mul_en_in == 1) begin
        mul_en_out_reg <= 1;
        mul_out_reg <= mul_a + mul_b * size;
      end else begin
        mul_en_out_reg <= 0;
        mul_out_reg <= 0;
      end
    end
  end

  // Input Registers
  always #$etime(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      mul_a_reg <= 0;
      mul_b_reg <= 0;
    end else begin
      // Update input registers based on input enable signal
      if (mul_en_in == 1) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
      end
    end
  end

  // Partial Product Generation
  always #$etime(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      for (int i = 0; i < size; i++) begin
        temp[i] <= 0;
      end
    end else begin
      // Generate partial products based on input bits
      for (int i = 0; i < size; i++) begin
        if (mul_a_reg[i] == 1 && mul_b_reg[i] == 1) begin
          temp[i] <= mul_a_reg[i] + mul_b_reg[i];
        end else begin
          temp[i] <= 0;
        end
      end
    end
  end

  // Partial Sum Calculation
  always #$etime(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      for (int i = 0; i < size; i++) begin
        sum[i] <= 0;
      end
    end else begin
      // Update partial sums based on input bits
      for (int i = 0; i < size; i++) begin
        if (temp[i] == 1) begin
          sum[i] <= sum[i] + temp[i];
        end else begin
          sum[i] <= 0;
        end
      end
    end
  end

  // Final Product Calculation
  always #$etime(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      mul_out_reg <= 0;
    end else begin
      // Sum up all partial sums to obtain final product
      for (int i = 0; i < size; i++) begin
        mul_out_reg <= mul_out_reg + sum[i];
      end
    end
  end

  // Output Assignment
  always #$etime(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      mul_out <= 0;
    end else begin
      // Assign output product value based on output enable signal
      if (mul_en_out == 1) begin
        mul_out <= mul_out_reg;
      end else begin
        mul_out <= 0;
      end
    end
  end