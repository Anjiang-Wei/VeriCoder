module parallel2serial(
    input        clk,       // system clock
    input        rst_n,     // active‐low reset
    input  [3:0] d,         // 4‐bit parallel input
    output       valid_out, // high for one cycle when MSB is being output
    output       dout       // serial data out (MSB first)
);

  //-----------------------------------------------------------------------------
  // Internal registers
  //-----------------------------------------------------------------------------
  reg [1:0] cnt;       // counts 0,1,2,3 cycles
  reg [3:0] data_reg;  // shift register

  //-----------------------------------------------------------------------------
  // Sequential block: reload or shift every clock
  //-----------------------------------------------------------------------------
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt      <= 2'd3;    // force reload on first active cycle
      data_reg <= 4'd0;
    end
    else if (cnt == 2'd3) begin
      // time to reload the 4‐bit parallel word
      data_reg <= d;
      cnt      <= 2'd0;
    end
    else begin
      // shift left: MSB moves out on dout, LSB slot zeros
      data_reg <= {data_reg[2:0], 1'b0};
      cnt      <= cnt + 2'd1;
    end
  end

  //-----------------------------------------------------------------------------
  // Outputs
  //-----------------------------------------------------------------------------
  // MSB of the shift register is the current serial output
  assign dout      = data_reg[3];

  // valid_out is asserted only in the cycle we just reloaded MSB
  assign valid_out = (cnt == 2'd0);

endmodule