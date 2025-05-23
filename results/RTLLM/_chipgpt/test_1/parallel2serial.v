module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg cnt;
reg [4:1] data; // 5-bit serial output
reg [2:0] s;
reg shifter; // 0=shift left, 1=shift right
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) cnt <= 0;
    else cnt <= cnt + 1;
end
//data for serial output is located in the flip-flops data[4:1]
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) {data, s} <= 0; //d0 becomes d4
    else if (cnt == 0) {data, s} = {data, s}; //d3 becomes d1
    else if (s == 0 && cnt == 4) data <= d[3:0]; //d7 becomes d0
    else if (s == 0 && cyt == 3) data <= {data[0], d[3:0]}; //d6 becomes d1
    else case (s) //s[2:0]=2'b?? will do the shift operation s[2:0]=3'b?1?
        2'b00:   data[4:1] = {data[4], s[3:1]}; //d7 becomes d3, d6 becomes d4, and d5 remains unchanged.
        2'b01:   data <= {s[3:1], data[4:0]}; //d6 becomes d7, d5 becomes d6, and d4 becomes d5.
        2'b10:   data <= s[3:1];                  //d3 becomes d4, d2 becomes d5, and d1 remains unchanged.
        default:   data <= {s[3:1], data[4:0]};    //d1 will become the most significant bit of d.
    endcase
end
//valid output is determined by data[4]. If s[2:0]=3'b??(data is 4-bit, so s will be 5-bit) then valid_out=1 and data[4] will become the most significant bit of d. Otherwise, if s[2:0]=3'b?1?, which indicates that we are shifting the serial output by one position, then valid_out=0
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) valid_out <= 0; //by default, the first bit of d is the most significant bit. So when cnt=4, data[4] will be a '1'.
    else if (s == 3 && cnt==4) valid_out <= 1; //if s equals with "?", which means to shift the serial output by one position, then the first bit of d is already the most significant bit. So when cynt=4 again, data[4] will be a '0'.
    else if (s != 3 && cnt!=4) valid_out <= 0;
end
assign dout = {data[4:1], ~valid_out}; //when the most significant bit of data is 0, then we know that data is a serial output. So when valid=1, the serial output will be {data[3:0], ~valid}, which means that only the msb needs to be outputted

endmodule