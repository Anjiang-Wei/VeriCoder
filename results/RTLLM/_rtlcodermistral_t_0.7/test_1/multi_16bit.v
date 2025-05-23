```verilog
    reg [15:0] areg;    // Multiplicand register.
    reg [15:0] breg;    // Multiplier register.
    reg [31:0] yout_r;   // Product register.
    reg [3:0] i;        // Shift count register.
    reg done_r;         // Multiplication completion flag register.

    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 4'b0;
            done_r <= 1'b0;
        end else begin
            if (start && i < 4'b111) begin
                i <= i + 1;
            end else if (!start) begin
                i <= 4'b0;
            end
            
            if (i == 4'b16) begin
                done_r <= 1'b1;
            end else if (i == 4'b17) begin
                done_r <= 1'b0;
            end

            if (start) begin
                if (i == 4'b0) begin
                    areg <= ain;
                    breg <= bin;
                end else if (i < 4'b17) begin
                    if (areg[i-1]) begin
                        yout_r <= {yout_r[31:i], breg << (i-1)};
                    end
                end
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule