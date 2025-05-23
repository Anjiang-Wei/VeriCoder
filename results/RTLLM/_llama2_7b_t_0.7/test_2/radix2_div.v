module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

  // Initialize the shift register and counter
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      SR <= 0;
      cnt <= 0;
      start_cnt <= 0;
    end else begin
      if (opn_valid && !res_ready) begin
        // Save the inputs
        dividend <= dividend;
        divisor <= divisor;

        // Initialize shift register and counter
        SR <= abs(dividend);
        cnt <= 1;
        start_cnt <= 1;
      end else if (cnt == 8) begin
        // Division is complete
        cnt <= 0;
        start_cnt <= 0;

        // Update result
        result <= SR;

        // Reset result valid flag
        res_valid <= 0;
      end else begin
        // Increment counter and update shift register
        cnt <= cnt + 1;
        SR <= abs(SR - neg_divisor);
      end
    end
  end

  // Reset valid flag when input ready signal goes high
  always @(*) begin
    res_valid <= 0;
  end

  // Drive output result ready signal based on result valid flag
  always @(*) begin
    if (res_valid) begin
      res_ready <= 1;
    end else begin
      res_ready <= 0;
    end
  end

endmodule