module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= 0;
    else state <= {state[0], wave};
end
assign wave = {state[1:0], (state == 3 && wave == 31)? 0 : (state == 0 ? 1 : -1 )};

endmodule