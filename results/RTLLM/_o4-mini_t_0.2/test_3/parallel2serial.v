module parallel2serial(
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

  // internal registers
  reg [1:0] cnt;
  reg [3:0] data;
  reg       valid;

  // synchronous logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // reset: force cnt=3 so that on next clock we load d immediately
      cnt   <= 2'b11;
      data  <= 4'b0000;
      valid <= 1'b0;
    end else begin
      if (cnt == 2'b11) begin
        // time to load new parallel word
        data  <= d;          // load full word
        cnt   <= 2'b00;      // start new 4-cycle window
        valid <= 1'b1;       // flag that dout = d[3] this cycle
      end else begin
        // rotate/shift for next bit out
        data  <= {data[2:0], data[3]};
        cnt   <= cnt + 1'b1;
        valid <= 1'b0;
      end
    end
  end

  // outputs
  assign dout      = data[3]; // always present MSB
  assign valid_out = valid;   // high only in the load cycle

endmodule