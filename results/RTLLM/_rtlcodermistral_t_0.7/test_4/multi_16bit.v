```verilog
    reg [15:0] areg, breg;
    reg [31:0] yout_r;
    reg [4:0] i;
    reg done_r;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            i <= 0;
            done_r <= 0;
        end else begin
            if (start && i < 17) begin
                i <= i + 1;
            end else if (!start) begin
                i <= 0;
            end
            if (i == 16) begin
                done_r <= 1;
            end else if (i == 17) begin
                done_r <= 0;
            end
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end else if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule