```verilog

    reg [15:0] areg;    // Multiplicand register
    reg [15:0] breg;    // Multiplier register
    reg [31:0] yout_r;   // Product register
    reg [3:0] i;        // Shift count register
    reg done_r;         // Multiplication completion flag register

    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            i <= 0;
            done_r <= 0;
        end
        else begin
            if (start && i < 17) begin
                i <= i + 1;
            end
            else if (!start) begin
                i <= 0;
            end

            if (i == 16) begin
                done_r <= 1;
            end
            else if (i == 17) begin
                done_r <= 0;
            end

            if (start && i == 0) begin
                areg <= ain;
                breg <= bin;
            end

            if (start && i > 0 && (i-1) < 16) begin
                if (areg[i-1]) begin
                    yout_r <= {yout_r[31:i], breg};
                end
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule