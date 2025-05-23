module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);
    reg [4:0] i;        // Shift count register.
    reg [15:0] areg;    // Multiplicand register.
    reg [15:0] breg;    // Multiplier register.
    reg [31:0] yout_r;  // Product register.
    reg done_r;         // Multiplication completion flag.

    // Shift count control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (start && i < 17) begin
            i <= i + 1;
        end else if (!start) begin
            i <= 5'd0;
        end
    end

    // Multiplication completion flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 16) begin
            done_r <= 1'b1;
        end else if (i == 17) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            case (i)
                5'd0: begin
                    areg <= ain;
                    breg <= bin;
                end
                5'd1: begin
                    if (areg[15]) yout_r <= yout_r + (breg << 1);
                end
                5'd2: begin
                    if (areg[14]) yout_r <= yout_r + (breg << 2);
                end
                5'd3: begin
                    if (areg[13]) yout_r <= yout_r + (breg << 3);
                end
                5'd4: begin
                    if (areg[12]) yout_r <= yout_r + (breg << 4);
                end
                5'd5: begin
                    if (areg[11]) yout_r <= yout_r + (breg << 5);
                end
                5'd6: begin
                    if (areg[10]) yout_r <= yout_r + (breg << 6);
                end
                5'd7: begin
                    if (areg[9]) yout_r <= yout_r + (breg << 7);
                end
                5'd8: begin
                    if (areg[8]) yout_r <= yout_r + (breg << 8);
                end
                5'd9: begin
                    if (areg[7]) yout_r <= yout_r + (breg << 9);
                end
                5'd10: begin
                    if (areg[6]) yout_r <= yout_r + (breg << 10);
                end
                5'd11: begin
                    if (areg[5]) yout_r <= yout_r + (breg << 11);
                end
                5'd12: begin
                    if (areg[4]) yout_r <= yout_r + (breg << 12);
                end
                5'd13: begin
                    if (areg[3]) yout_r <= yout_r + (breg << 13);
                end
                5'd14: begin
                    if (areg[2]) yout_r <= yout_r + (breg << 14);
                end
                5'd15: begin
                    if (areg[1]) yout_r <= yout_r + (breg << 15);
                end
                5'd16: begin
                    if (areg[0]) yout_r <= yout_r + (breg << 16);
                end
                default: begin
                    yout_r <= yout_r;
                end
            endcase
        end
    end

    // Output assignment
    assign yout = yout_r;
    assign done = done_r;

endmodule