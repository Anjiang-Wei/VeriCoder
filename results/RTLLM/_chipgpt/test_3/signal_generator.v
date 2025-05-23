module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

reg state;
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= 0;
    else state <= {state[1:0], !state};
end
assign wave = state ? 32 - (wave == 31) : state ? 32 - (wave + 1) : i++;
always @(*) begin
    case (state)
        0: if (i >= 50) i = 49;
        1: i = 0;
        default: i = i + 1;
    endcase
end

endmodule