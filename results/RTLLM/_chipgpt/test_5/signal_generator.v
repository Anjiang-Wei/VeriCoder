module top_module (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;
reg done;
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= 0;
    else state <= {state[0], done};
end
always @* begin
    wave = state ? 1 : 31; // Increment by one
    done = wave == 31;
    case (state)
        0: if (wave < 31) wave++;
        default: wave = 0;
    endcase
end
endmodule