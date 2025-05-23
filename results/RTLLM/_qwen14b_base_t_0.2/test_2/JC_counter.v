module JC_counter(
   input                clk ,
   input                rst_n,
   output reg [63:0]    Q  
);
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         Q <= 64'b0;  // Reset the counter to 0
      end else begin
         case (Q[0])
            1'b0: begin  // If LSB is 0, increment by appending 1 at MSB
               Q <= {Q[62:0], 1'b1};
            end
            1'b1: begin  // If LSB is 1, decrement by appending 0 at MSB
               Q <= {Q[62:0], 1'b0};
            end
            default: begin
               Q <= Q;  // This is a safeguard, should not be reached
            end
         endcase
      end
   end
   
endmodule