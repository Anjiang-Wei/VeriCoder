module multi_booth_8bit (
    output reg [15:0] p,
    output reg        rdy,
    input             clk,
    input             reset,
    input      [7:0]  a,
    input      [7:0]  b
);

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0]  ctr;    // needs to count up to 16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign‐extend inputs to 16 bits
            multiplicand <= {{8{b[7]}}, b};
            multiplier   <= {{8{a[7]}}, a};
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // If the current bit of the multiplier is '1', add shifted multiplicand
                if (multiplier[ctr])
                    p <= p + multiplicand;
                // Shift multiplicand left by 1 for the next bit
                multiplicand <= multiplicand << 1;
                // Move to next bit
                ctr <= ctr + 1;
            end else begin
                // All bits processed; signal ready
                rdy <= 1'b1;
            end
        end
    end

endmodule