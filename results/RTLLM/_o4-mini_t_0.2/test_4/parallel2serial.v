module parallel2serial(
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

  // internal registers
  reg  [1:0] cnt;
  reg  [3:0] data_reg;
  reg        valid;

  // counter, shift‐register and valid generation
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt       <= 2'b11;     // force a reload on the first active cycle
      data_reg  <= 4'b0000;
      valid     <= 1'b0;
    end else begin
      if (cnt == 2'b11) begin
        // load new parallel word, assert valid for MSB
        data_reg <= d;
        cnt      <= 2'b00;
        valid    <= 1'b1;
      end else begin
        // shift/circular rotate left
        data_reg <= {data_reg[2:0], data_reg[3]};
        cnt      <= cnt + 1;
        valid    <= 1'b0;
      end
    end
  end

  // outputs
  assign dout      = data_reg[3]; // always drive MSB of shift register
  assign valid_out = valid;

endmodule