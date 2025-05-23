module wave_generator(
    input clk,
    input rst_n,
    output reg [5:0] state,
    output reg [5:0] wave
);

reg [1:0] temp;
parameter inc = 2'b00,
          dec = 2'b01,
          idle = 2'b10;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= idle;
    else state <= state << inc;
end
assign {wave, temp} = state ? (inc == dec ? {wave[+1:0], state} : {wave[-1:0], state})
                         : (inc == inc ? {state, wave} : {state, temp});

endmodule