module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

reg [15:0] areg;      // Multiplicand register
reg [15:0] breg;      // Multiplier register
reg [31:0] yout_r;    // Product register

wire [4:0] i;         // Shift count register (5-bit wide, since it counts from 16 to 0)

reg done_r;           // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= '0;
        done_r <= '0;
        areg <= '0;
        breg <= '0;
        yout_r <= '0;
    end else if (start && !done_r) begin
        if (i < 17) i <= i + 1'b1;
    end else if (!start) begin
        i <= '0;
        done_r <= '0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout_r <= '0;
    end else if (i < 16) begin
        if (areg[i-1]) yout_r <= {<<{breg,32'b0} >> i-1, yout_r[31:>>i]};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || start) begin
        areg <= ain;
        breg <= bin;
    end else if (done_r) begin
        areg <= '0;
        breg <= '0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (i == 16) done_r <= 1'b1;
    else if (!start || i == 17) done_r <= 1'b0;
end

assign yout = yout_r;

endmodule