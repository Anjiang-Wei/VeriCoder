module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg state; //0: no pulse, 1:pulse in progress, 2:end of pulse
reg pulse_count;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) state <= 0;
    else state <= {state, data_in};
end
always @* begin
    data_out = 1'b0;
    case (state)
        2'b01: pulse_count <= 0; //no pulse
        2'b10: if(pulse_count > 1) pulse_count <= 0; //end of pulse
        default: pulse_count <= 0;
    endcase
    data_out = state==2'b11 && pulse_count == 3 ? 1'b1 : 1'b0;
end

endmodule