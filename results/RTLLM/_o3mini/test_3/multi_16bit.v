module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. 0 for chip reset; 1 for inactive reset.
    input start,        // Chip enable signal.
    input [15:0] ain,   // Multiplicand (a) input with 16 bits.
    input [15:0] bin,   // Multiplier (b) input with 16 bits.

    output [31:0] yout, // Product output with 32 bits.
    output done         // Flag signal: 1 indicates multiplication operation completion.
);

    // Internal registers.
    reg [4:0] i;         // Shift count register (needs 5 bits to count up to 17).
    reg done_r;          // Internal done flag.
    reg [15:0] areg;     // Stored multiplicand register.
    reg [15:0] breg;     // Stored multiplier register.
    reg [31:0] yout_r;   // Accumulated product register.

    // Shift count register update.
    // This block updates the counter 'i' at each positive clock edge or asynchronous reset.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start) begin
            // If start is active and the counter is less than 17, increment.
            if (i < 5'd17)
                i <= i + 5'd1;
            else
                i <= i;
        end
        else begin
            // When start is inactive, reset the counter.
            i <= 5'd0;
        end
    end

    // Multiplication completion flag generation.
    // Sets done_r to 1 when i equals 16 and resets it when i equals 17.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
        else
            done_r <= done_r;
    end

    // Shift and accumulate operation.
    // Uses the shift count (i) and accumulated product register (yout_r) to perform multiplication.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
        else if (start) begin
            // When starting, for i == 0 load multiplicand and multiplier.
            if (i == 5'd0) begin
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end
            // For i values 1 to 16, shift and accumulate operation.
            // Note: We examine bit (i-1) of the stored multiplicand.
            else if (i <= 5'd16) begin
                // If the corresponding bit in areg is high, add (breg shifted by i-1) to yout_r.
                if (areg[i-1])
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
                else
                    yout_r <= yout_r;
            end
        end
    end

    // Output assignments.
    assign yout = yout_r;
    assign done = done_r;

endmodule