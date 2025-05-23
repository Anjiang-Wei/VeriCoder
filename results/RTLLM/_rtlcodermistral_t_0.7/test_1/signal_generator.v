```verilog
  reg [1:0] state;
  parameter IDLE = 2'b00;
  parameter INC = 2'b01;
  parameter DEC = 2'b10;
  
  always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
      state <= IDLE;
      wave <= 0;
    end
    else begin
      case (state)
        IDLE: begin
          wave <= wave + 1;
          if (wave == 31) begin
            state <= INC;
          end
        end
        INC: begin
          wave <= wave - 1;
          if (wave == 0) begin
            state <= DEC;
          end
        end
        DEC: begin
          wave <= wave + 1;
          if (wave == 31) begin
            state <= IDLE;
          end
        end
      endcase
    end
  end
  
endmodule