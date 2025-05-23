module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Data bit control signals
localparam SHIFT_COUNT_MAX = 16;
localparam SHIFT_COUNT_STEP = 1;

logic [15:0] shift_count, i;
logic [15:0] done_r;
logic [31:0] yout_r;

// Module inputs
input clk;
input rst_n;
input start;
input [15:0] ain;
input [15:0] bin;

// Module outputs
output [31:0] yout;
output done;

// Shift and accumulate operation
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_count <= 0;
        i <= 0;
    end else begin
        // Update shift count on positive edge of clock
        if (shift_count < SHIFT_COUNT_MAX) begin
            shift_count <= shift_count + SHIFT_COUNT_STEP;
        end else begin
            shift_count <= 0;
        end

        // Update done flag on positive edge of clock
        if (shift_count == SHIFT_COUNT_MAX) begin
            done_r <= 1;
        end else begin
            done_r <= 0;
        end

        // Perform shift and accumulate operation
        if (start && shift_count < SHIFT_COUNT_MAX) begin
            yout_r <= ain << i;
            i += 1;
        end
    end
end

// Multiplication completion flag generation
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 0;
    end else begin
        // Update done flag on positive edge of clock
        if (shift_count == SHIFT_COUNT_MAX) begin
            done_r <= 1;
        end else begin
            done_r <= 0;
        end
    end
end

// Output assignment
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout <= 0;
        done <= 0;
    end else begin
        yout <= yout_r;
        done <= done_r;
    end
end