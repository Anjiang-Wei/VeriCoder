* Registers should be named clearly and have meaningful names.
  * Constants should be defined using `parameter` statements.
  * The code should be properly formatted and indented.
  * The code should be structured using modules and functions where appropriate.
  * Functions should be named clearly and have meaningful names.
  * The code should be modular, well-structured, and easy to understand.

```verilog
  parameter STATE_0 = 0;
  parameter STATE_1 = 1;
  reg [1:0] state = STATE_0;
  always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      state <= STATE_0;
      wave <= 0;
    end
    else begin
      case (state)
        STATE_0: begin
          wave <= wave + 1;
          if (wave == 31) begin
            state <= STATE_1;
          end
        end
        STATE_1: begin
          wave <= wave - 1;
          if (wave == 0) begin
            state <= STATE_0;
          end
        end
      endcase
    end
  end
endmodule