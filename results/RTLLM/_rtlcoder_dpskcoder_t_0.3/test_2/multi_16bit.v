module top_module(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [4:0] i;
reg [15:0] areg, breg;
reg [31:0] yout_r;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        if (start && (i < 17)) begin
            i <= i + 1;
        end else begin
            i <= 0;
        end
        if (i == 16) begin
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
        end
        if (start) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end else if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end else begin
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            done_r <= 0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule