always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      Q <= 64'b0;
    else
      Q <= {Q[62:0], ~Q[63]};
  end
endmodule