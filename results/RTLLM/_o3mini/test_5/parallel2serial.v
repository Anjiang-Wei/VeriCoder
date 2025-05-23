module parallel2serial(
    input         clk,      // Clock signal for synchronous operations
    input         rst_n,    // Active-low reset signal
    input  [3:0]  d,        // 4-bit parallel data input
    output        valid_out,// Valid signal for serial output availability
    output        dout      // Serial data output
);

  // Internal registers
  reg [3:0] data;   // Internal data register that holds the currently shifting data
  reg [1:0] cnt;    // 2-bit counter (counts 0,1,2,3)
  reg       valid;  // Valid signal register

  // Sequential process for counter and shifting logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // On reset, clear the counter, register, and valid signal.
      cnt   <= 2'd0;
      data  <= 4'd0;
      valid <= 1'b0;
    end
    else begin
      if (cnt == 2'd3) begin
        // At the 4th cycle: output the MSB and load new data.
        data  <= d;    // Reload the parallel data input
        cnt   <= 2'd0; // Reset counter back to zero
        valid <= 1'b1; // Valid output is high indicating a new valid bit is output
      end
      else begin
        // For cycles 1 to 3:
        cnt   <= cnt + 2'd1;                  // Increment counter
        valid <= 1'b0;                        // Valid signal is low during shifting
        // Circular left shift: shift left by 1 bit with wrap-around of the MSB to LSB.
        data  <= {data[2:0], data[3]};
      end
    end
  end

  // The serial output is always the MSB of the internal data register.
  assign dout = data[3];
  // The valid signal for output comes from the internal valid register.
  assign valid_out = valid;

endmodule