module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

wire [15:0] i;
reg [16:0] shift_count_reg,i;
reg[15:0] areg,breg;
reg [31:0] yout_r,yout;  //product register(yout) and completed flag (done).

//Data bit control
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)   shift_count_reg<=0;
    else            shift_count_reg<=i+1;
end

always @* begin
    i=shift_count_reg;
    done=0;
    if(start && (i==16)) begin //checks if the i is equal to 16 which indicates that we're in the last digit of multiplication.
        i<=0;
        areg<=ain;
        breg<=bin;
        done=1;
    end
    else if(start && (i<16)) begin //checks if the i is less than 17 which means that we're in the middle of multiplication.
         i=i+1;
         if(!rst_n) begin //if reset signal (rst_n) is active then registers are cleared to zero
             areg<=0;
             breg<=0;
         end
         else begin    //else the register will be incremented by one.
               if(i==16 && done) //checks if the i is equal to 16 which indicates that we're in the last digit of multiplication
                   yout_r=areg+breg;
               else if (i<16) //the value at position i-1 in the multiplicand register is high. So we shifted breg left by i-1 positions and will add 0's on its least significant bit.
                   yout_r=areg+breg[i-1:0];//we can also use {i-1{breg,0}} but this is more compact and less time consuming
               else begin //if i>15 it means that the multiplication operation has finished so we should reset our registers.
                   yout_r=areg+breg;
               end
         end
    end
end
assign yout=(i==0)?{16'hFFFF_FFFF}:yout_r;  //use 256-bit hexadecimal number to prevent overflowing. The product will be displayed on the display module directly after multiplying it with 10. This means that the output value of this module is equal to {16'hFF_FFFF_FFFF,16'hFFF_FFF5}.
assign done=(i==0)?1:0;   //if i=0 which means completion, then the flag will be 1. If not, it will be 0. The completed signal (done) is used by the display module to indicate the time when the multiplication operation will finish.

endmodule