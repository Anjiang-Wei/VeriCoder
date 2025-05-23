The remaining code is as follows:

```verilog
  reg [1:0] state;
  reg [7:0] cnt;
  reg p_red, p_yellow, p_green;

  always @(*)
  begin
    case (state)
      idle: state = s1_red;
      s1_red: state = (cnt == 0) ? s3_green : s1_red;
      s2_yellow: state = (cnt == 0) ? s1_red : s2_yellow;
      s3_green: state = (cnt == 0) ? s2_yellow : s3_green;
      default: state = s1_red;
    endcase
  end

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      cnt <= 10;
    else
    begin
      if (pass_request && green)
        cnt <= 10;
      else if (!green && p_green)
        cnt <= 60;
      else if (!yellow && p_yellow)
        cnt <= 5;
      else if (!red && p_red)
        cnt <= 10;
      else
        cnt <= cnt - 1;
    end
  end

  assign clock = cnt;

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      red <= 0;
      yellow <= 0;
      green <= 0;
    end
    else
    begin
      red <= p_red;
      yellow <= p_yellow;
      green <= p_green;
    end
  end

endmodule