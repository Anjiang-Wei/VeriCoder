module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

reg state;
reg [4:0] wave;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= 0;
    else begin
        case (state)
            0: if (wave == 31) state <= 1;
            default: state <= 0;
        endcase
    end
end
always @* begin
   wave = 5'b0;
   case (state)
      0:
          wave[4] = ~wave[4];
      1:
          wave[3:0] = ~wave[3:0];
   endcase
end

endmodule