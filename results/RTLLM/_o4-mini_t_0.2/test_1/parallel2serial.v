module parallel2serial(
    input        clk,
    input        rst_n,     // active low reset
    input  [3:0] d,         // parallel data in
    output       valid_out, // high for one cycle when MSB is first shifted out
    output       dout       // serial data out, MSB first
);

  reg [3:0] data;   // shift register
  reg [1:0] cnt;    // 2‐bit counter 0..3
  reg       valid;  // internal valid flag

  // synchronous process: reload or shift each clock
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data  <= 4'b0000;
      cnt   <= 2'b00;
      valid <= 1'b0;
    end else begin
      if (cnt == 2'b11) begin
        // end of a frame => load new parallel word,
        // reset counter, assert valid for this MSB
        data  <= d;
        cnt   <= 2'b00;
        valid <= 1'b1;
      end else begin
        // shift the register (rotate left), advance counter,
        // valid only on reload cycle
        data  <= {data[2:0], data[3]};
        cnt   <= cnt + 1'b1;
        valid <= 1'b0;
      end
    end
  end

  // outputs
  assign dout      = data[3];
  assign valid_out = valid;

endmodule