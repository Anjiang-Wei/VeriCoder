module multi_16bit(
    input             clk,    // Chip clock signal.
    input             rst_n,  // Active-low reset signal.
    input             start,  // Start pulse to begin multiplication.
    input      [15:0] ain,    // Multiplicand.
    input      [15:0] bin,    // Multiplier.
    output reg [31:0] yout,   // 32-bit product output.
    output            done    // Goes high for one cycle when product is ready.
);

    // internal registers
    reg [4:0]   i;       // shift/step counter (0..17)
    reg         done_r;  // done flag
    reg [15:0]  areg;    // holds multiplicand
    reg [15:0]  breg;    // holds multiplier
    reg [31:0] yout_r;   // accumulator

    // shift count logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            // if start de-asserted, go back to step 0
            i <= 5'd0;
        end else if (i < 5'd17) begin
            // advance through 0..17
            i <= i + 5'd1;
        end
    end

    // done flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            // one cycle after last add step
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            // clear again before going back to 0
            done_r <= 1'b0;
        end
    end

    // shift-and-accumulate datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // load inputs and clear accumulator
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if ((i > 5'd0) && (i < 5'd17)) begin
                // for each bit of areg, if it is '1', add (breg << (i-1))
                if (areg[i-1]) begin
                    // zero-extend breg to 32 bits before shifting
                    yout_r <= yout_r + ({16'd0, breg} << (i-1));
                end
            end
            // else: no action on step 17
        end
        // if start==0 we simply hold our registers until next start
    end

    // output assignments
    always @(*) begin
        yout = yout_r;
    end

    assign done = done_r;

endmodule