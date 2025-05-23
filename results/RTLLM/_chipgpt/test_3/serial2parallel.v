//Use 4-bit counter to keep track of the number of input bits.
always @(posedge clk) begin
    if(!rst_n) cnt <= 0;
    else if(din_valid && din_serial == 8'b1) begin //MSB is 8th bit and will be output as parallel
        cnt <= cnt + 1;
    end
    else cnt <= cyt;
end
//Output dout_parallel when all eight bits have been received.
assign dout_parallel = {dout_parallel[3:0], cnt};
//Output valid if all the input data has been received.
assign dout_valid = cnt == 8 ? 1 : 0;

endmodule