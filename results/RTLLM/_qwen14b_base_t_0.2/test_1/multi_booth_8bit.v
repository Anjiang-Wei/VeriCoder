`timescale 1ns / 1ps
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   reg [15:0] p;
   reg rdy;
   reg [15:0] multiplier;
   reg [15:0] multiplicand;
   reg [4:0] ctr;

   // Initialize registers on reset
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         p <= 16'b0;
         rdy <= 1'b0;
         multiplier <= {8{a[7]}}, a;
         multiplicand <= {8{b[7]}}, b;
         ctr <= 5'b0;
      end else begin
         if (ctr < 16) begin
            // Left shift multiplicand
            multiplicand <= {multiplicand[14:0], 1'b0};

            // Check Booth encoding
            case (multiplier[ctr+1:ctr])
               2'b00: begin
                  // No operation
               end
               2'b01: begin
                  p <= p + multiplicand;
               end
               2'b10: begin
                  p <= p - multiplicand;
               end
               2'b11: begin
                  // No operation
               end
               2'b10: begin
                  p <= p - multiplicand;
               end
            endcase

            // Increment counter
            ctr <= ctr + 1;
         end else begin
            // Multiplication complete
            rdy <= 1'b1;
         end
      end
   end

   // Booth encoding for Radix-4
   always @(posedge clk or posedge reset) begin
      if (reset) begin
         multiplier <= {8{a[7]}}, a;
      end else begin
         if (ctr < 16) begin
            // Update multiplier based on Booth encoding
            case (multiplier[ctr+2:ctr])
               3'b000: multiplier[ctr+2:ctr] <= 3'b000;
               3'b001: multiplier[ctr+2:ctr] <= 3'b000;
               3'b010: multiplier[ctr+2:ctr] <= 3'b000;
               3'b011: multiplier[ctr+2:ctr] <= 3'b001;
               3'b100: multiplier[ctr+2:ctr] <= 3'b000;
               3'b101: multiplier[ctr+2:ctr] <= 3'b010;
               3'b110: multiplier[ctr+2:ctr] <= 3'b100;
               3'b111: multiplier[ctr+2:ctr] <= 3'b101;
            endcase
         end
      end
   end

endmodule