module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);
    reg [15:0] areg;    // Register for multiplicand
    reg [15:0] breg;    // Register for multiplier
    reg [31:0] yout_r;  // Register for product output
    reg [4:0] i;        // Shift count register
    reg done_r;         // Completion flag

    // Data bit control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else if (start && (i < 17)) begin
            if (i == 16'b0) begin
                areg <= ain;
                breg <= bin;
            end else begin
                if (areg[15]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
            end
            i <= i + 1'b1;
        end else if (!start) begin
            i <= 5'b0;
        end
    end

    // Multiplication completion flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (start && (i == 16)) begin
            done_r <= 1'b1;
        end else if ((i == 17) || (!start)) begin
            done_r <= 1'b0;
        end
    end

    // Output assignment
    assign yout = yout_r;
    assign done = done_r;
endmodule