module JC_counter(
   input                clk ,
   input                rst_n,
 
   output reg [63:0]     Q  
);

// Define the reset signal and the initial value of the counter
always #100 rst_n = 0; // Reset signal is low for 100 clock cycles
Q = 0; // Initial value of the counter

// Update the counter on each clock edge or reset pulse
always @(posedge clk or negedge rst_n) begin
   if (rst_n == 0) begin // Reset condition
      Q <= 0; // Set the counter to 0
   end else begin // Non-reset condition
      Q <= Q >> 1 & ~Q[5]; // Update the counter value
   end
end