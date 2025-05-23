module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Data bit control declaration
reg [15:0] i;

// Multiplication completion flag generation declaration
reg done_r;
always @(posedge clk, negedge rst_n) begin
    if (!rst_n)  // Chip reset.
        i <= 'd0;
    else if (start && ~done_r) // If the start signal is active and the multiplication completion flag is not set to "1" yet.
        i <= i+1;
    else 
        i <= 'd0;
end

// Multiplication operation declaration
always @(posedge clk, negedge rst_n) begin
    if (!rst_n)  // Chip reset.
        yout <= 'd0;
    else if (i == 'd16) // When the shift count register is equal to 16, indicating the completion of the multiplication operation.
        done_r <= 'd0;
    else if (i < 'd16) begin  // Shift and accumulate operation.
        if(~done_r && ~(start || !start)) {// Multiplicand register, multiplier register and product register are reset to "0" when the start signal is inactive.
            yout <= 'd0;  
            ain <= 'd0;
            bin <= 'd0;
        } else if(i == 'd15) { // When i is equal to 15, indicating that all the bits of the multiplicand register have been stored.
            bin <= bin + ain;
        } else {   // Shift and accumulate operation for shift count greater than 0 and less than 17.
            if(i-1 > 'd0 && ~done_r) yout <= (bin << i) + yout;   // The product register is updated by appending zeros to the least significant bit positions of the multiplier register when it is shifted left for the number of times indicated in i.
        }
    end 
end

endmodule