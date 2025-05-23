module JC_counter(
   input                clk ,
   input                rst_n,
 
   output reg [63:0]     Q  
);

  reg [63:0] temp;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      Q <= 64'b0;
    end
    else begin
      if(Q[0] == 1'b0) begin
        temp = {1'b1, Q[63:1]};
      end
      else begin
        temp = {1'b0, Q[63:1]};
      end
      Q <= temp;
    end
  end

endmodule