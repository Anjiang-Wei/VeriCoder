module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

  // Data bit control signals
  always #10 clk == (rst_n = 0) begin
    i <= 0;
  end
  
  always #10 clk == (rst_n = 1) begin
    i <= 0;
  end
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      i <= 0;
    end else begin
      case (i)
        0: begin
            if (start) begin
              i <= i + 1;
            end
          end
          16: begin
            yout <= bin * ain;
            done <= 1;
            i <= 0;
          end
          default: begin
            i <= i + 1;
          end
      endcase
    end
  end