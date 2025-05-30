```verilog
  always @(posedge clk, negedge rst_n)
  begin
    if (~rst_n)
      out <= 4'b0000;
    else if (valid_count)
    begin
      if (out == 4'd11)
        out <= 4'b0000;
      else
        out <= out + 1;
    end
  end
endmodule