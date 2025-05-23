module top_module (
    input clk,
    input rst_n,
    input [7:0] din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [3:0] cnt;
reg [7:0] dout_parallel_reg;
reg dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'b0;
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
    end
    else begin
        if (din_valid) begin
            dout_parallel_reg[cnt] <= din_serial;
            cnt <= cnt + 1;
            if (cnt == 4'b1111) begin
                dout_valid_reg <= 1'b1;
            end
            else begin
                dout_valid_reg <= 1'b0;
            end
        end
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule