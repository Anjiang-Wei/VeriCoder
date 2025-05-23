module multi_16bit (
    input clk,                      // Chip clock signal.
    input rst_n,                     // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,                     // Chip enable signal.
    input [15:0] ain,                // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,                // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout,               // Product output with a data width of 32 bits.
    output done                      // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Data bit control declaration
reg [4:0] i;
// Multiplication completion flag generation
reg done_r;
// Shift and accumulate operation
wire [31:0] areg, breg, yout_r;
assign {yout, done} = {yout_r, done}; // Store the product output to 'yout' and multiplication completion flag to 'done'.
always @(posedge clk or negedge rst_n) begin : data_bit_control
    if (~rst_n) i <= 0;
    else if (start && !start && i < 17) i <= i + 1; // Shift count register (i) is equal to 16 indicating the completion of multiplication operation.
    else i <= 0;
end

always @(posedge clk or negedge rst_n) begin : shift_and_accumulate
    if (~rst_n) {areg, breg} <= 'd0; // Reset multiplicand register and product register to zero.
    else if (start && i < 17) begin
        if ((i == 16 || i == 17)) done_r = 1'b0; // Shift count register (i) is equal to 16 indicating the completion of multiplication operation.
        else if (i < 17 && {areg[i-1], bin}) yout_r <= breg << i + 'd0; // Shift and accumulate operation. When the shift count register (i) is 0, the multiplicand (ain) and multiplier (bin) are stored in the respective registers (areg and breg). For shift counts greater than 0 and less than 17, if the bit at position i-1 in the multiplicand register (areg) is high, the product register (yout_r) accumulates the shifted value of the multiplier register (breg) by shifting it left by i-1 positions and appending zeros at the least significant bit positions.
    end
end
endmodule