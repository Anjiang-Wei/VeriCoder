module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

  // Register to hold the previous value of signal a.
  reg a_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a_reg <= 1'b0;
      rise  <= 1'b0;
      down  <= 1'b0;
    end
    else begin
      // Detect rising edge: previous a = 0 and current a = 1.
      rise  <= (~a_reg) & a;
      
      // Detect falling edge: previous a = 1 and current a = 0.
      down  <= a_reg & (~a);
      
      // Update the stored value of a.
      a_reg <= a;
    end
  end

endmodule