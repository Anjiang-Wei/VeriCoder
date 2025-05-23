module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

wire i; // shift count register (i)
wire [15:0] areg, breg, yout_r; // registers for multiplicand (a), multiplier (b), and product (yout)
reg done_r;        // multiplication completion flag. Defined as 1 indicates the completion of the multiplication operation.

// Data bit control
assign i = {start, rst_n, start};
always @(posedge clk or negedge rst_n)
    if (!rst_n) i <= 0;
    else if (~start) i <= 0;
    else begin
        i[15] <= i[14];
        i[14] <= i[13];
        i[13] <= i[12];
        i[12] <= i[11];
        i[11] <= i[10];
        i[10] <= i[9];
        i[9] <= i[8];
        i[8] <= i[7];
        i[7] <= i[6];
        i[6] <= i[5];
        i[5] <= i[4];
        i[4] <= i[3];
        i[3] <= i[2];
        i[2] <= i[1];
        i[1] <= 0;
    end

// Shift and accumulate operation
always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
        areg <= 'd0;
        breg <= 'd0;
        done_r <= 0;
    end
    else if (i == 16) begin
        done_r <= 1;
        areg <= ain;
        breg <= bin;
    end
    else if (!start) done_r <= 0;
    else begin
        done_r <= 0;
        if ((i == 17 || i == 16) && ~(areg[15] || breg[15])) begin
            yout_r <= areg + breg - 'd{1,0}; // shifted by i-1 positions and appending zeros at the least significant bit positions.
        end else if (i > 0 && i < 17) {
            yout_r <= areg << i | breg[i:0];
        } else yout_r <= 'd0;
    end
assign done = done_r;
assign yout = yout_r;

endmodule