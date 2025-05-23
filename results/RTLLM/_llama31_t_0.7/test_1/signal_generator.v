module signal_generator(
  input clk,
  input rst_n,
  output reg [4:0] wave
);

// Internal registers to store state and waveform
reg [1:0] state; // Controls the waveform generation

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    state <= 2'b00;
    wave <= 5'h0;
  end else begin
    case (state)
      2'b00: begin
        wave <= wave + 1'd1;
        if (wave == 5'h1F)
          state <= 2'b01;
      end
      2'b01: begin
        wave <= wave - 1'd1;
        if (wave == 5'h0)
          state <= 2'b00;
      end
    endcase
  end
end

endmodule