module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

reg [15:0] areg, breg; // Registers for multiplicand and multiplier.
reg [31:0] yout_r;     // Register for product output.
reg [3:0] i;           // Shift count register.
reg done_r;            // Multiplication completion flag.

// Data bit control.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
        i <= 4'b0;
        done_r <= 1'b0;
    end else if (start && (i < 17)) begin
        areg <= ain;
        breg <= bin;
        if (!start) begin
            i <= 4'b0;
        end else begin
            i <= i + 1'b1;
        end
    end
end

// Multiplication completion flag generation.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else if (i == 16) begin
        done_r <= 1'b1;
    end else if (i == 17) begin
        done_r <= 1'b0;
    end
end

// Shift and accumulate operation.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout_r <= 32'b0;
    end else if (start) begin
        if (i == 16'b0) begin
            yout_r <= {16'b0, bin};
        end else if ((i > 16'b0) && (i < 17)) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + ({16'b0, bin} << (i-1));
            end
        end
    end
end

// Output assignment.
assign yout = yout_r;
assign done = done_r;

endmodule