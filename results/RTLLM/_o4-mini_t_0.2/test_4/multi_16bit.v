module multi_16bit(
    input           clk,        // Chip clock signal.
    input           rst_n,      // Active-low reset signal. 0 = reset, 1 = normal operation.
    input           start,      // Chip enable signal to initiate multiplication.
    input   [15:0]  ain,        // Multiplicand (a).
    input   [15:0]  bin,        // Multiplier (b).
    output  [31:0]  yout,       // Product output.
    output          done        // Signal goes high for one cycle when the multiply is complete.
);

    //-------------------------------------------------------------------------
    // Internal registers
    //-------------------------------------------------------------------------
    reg  [4:0]   cnt;       // Shift‐count register: counts from 0 to 17
    reg          done_r;    // Completion flag (one‐cycle pulse at count==16)
    reg  [15:0]  areg;      // Registered multiplicand
    reg  [15:0]  breg;      // Registered multiplier
    reg  [31:0]  yreg;      // Accumulator / product register

    //-------------------------------------------------------------------------
    // Shift‐count logic
    //-------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 5'd0;
        end else begin
            if (!start) begin
                cnt <= 5'd0;
            end else if (cnt < 5'd17) begin
                cnt <= cnt + 5'd1;
            end
            // else hold at 17
        end
    end

    //-------------------------------------------------------------------------
    // Done flag generation
    //   done_r = 1 only when cnt == 16, back to 0 at cnt == 17
    //-------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (cnt == 5'd16) begin
                done_r <= 1'b1;
            end else if (cnt == 5'd17) begin
                done_r <= 1'b0;
            end
            // else retain previous
        end
    end

    //-------------------------------------------------------------------------
    // Shift‐and‐accumulate datapath
    //-------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            yreg <= 32'd0;
        end else if (start) begin
            case (cnt)
                5'd0: begin
                    // Load inputs at the start of operation
                    areg <= ain;
                    breg <= bin;
                    yreg <= 32'd0;
                end
                5'd1, 5'd2, 5'd3, 5'd4,
                5'd5, 5'd6, 5'd7, 5'd8,
                5'd9, 5'd10,5'd11,5'd12,
                5'd13,5'd14,5'd15,5'd16: begin
                    // For each bit position i-1, if bit is high add (breg << (i-1))
                    if (areg[cnt-1]) begin
                        yreg <= yreg + ({{16{1'b0}}, breg} << (cnt-1));
                    end
                end
                default: begin
                    // cnt == 17 or beyond: no action
                end
            endcase
        end
        // if !start, retain registers until reset or restart
    end

    //-------------------------------------------------------------------------
    // Output assignments
    //-------------------------------------------------------------------------
    assign yout = yreg;
    assign done = done_r;

endmodule