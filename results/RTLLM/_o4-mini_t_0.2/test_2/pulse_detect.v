module pulse_detect(
    input        clk,
    input        rst_n,
    input        data_in,
    output reg   data_out
);

  // small shift register to hold past two samples
  reg data_d1;
  reg data_d2;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_d1   <= 1'b0;
      data_d2   <= 1'b0;
      data_out  <= 1'b0;
    end else begin
      // shift in the new sample
      data_d2   <= data_d1;
      data_d1   <= data_in;

      // detect the pattern 0 -> 1 -> 0
      if (data_d2==1'b0 && data_d1==1'b1 && data_in==1'b0)
        data_out <= 1'b1;
      else
        data_out <= 1'b0;
    end
  end

endmodule