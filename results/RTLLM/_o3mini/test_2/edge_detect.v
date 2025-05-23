module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

  // Register to store the previous value of 'a'
  reg prev_a;
  
  // Edge detection happens at the positive edge of clock.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Active-low reset: initialize registers.
      prev_a <= 1'b0;
      rise   <= 1'b0;
      down   <= 1'b0;
    end
    else begin
      // Detect rising edge: a goes from 0 to 1.
      if ((prev_a == 1'b0) && (a == 1'b1))
        rise <= 1'b1;
      else
        rise <= 1'b0;
      
      // Detect falling edge: a goes from 1 to 0.
      if ((prev_a == 1'b1) && (a == 1'b0))
        down <= 1'b1;
      else
        down <= 1'b0;
      
      // Update stored value for next cycle.
      prev_a <= a;
    end  
  end

endmodule