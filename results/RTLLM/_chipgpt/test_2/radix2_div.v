localparam NEG_DIVISOR = 8'b00000001;
reg cnt;         //counter for division process
reg start_cnt;   //flag to start the division process (must be less than 8)
reg[7:0] SR;     //shift register of remainder and quotient
wire[7:0] temp,  //temporary register of subtraction result
c1, c2;         //outputs for multiplexer
integer i;        //counter to save the value in the "temp" register (8 bits)
always@(posedge clk or negedge rst) begin : m0
    if(!rst) begin
		cnt <= 0;
		start_cnt <= 0;
		SR <= 0;
    end
    else begin
        if (opn_valid && res_ready) begin //save the inputs as result is ready
            SR <= {dividend, divisor};         //shift left one bit to save absolute value in SR
            start_cnt <= 1;                      //start division process
        end
    end
end
always@(posedge clk or negedge rst) begin : m1
    if(!rst) begin
	temp[7:0] <= 8'b0;
    end
    else begin   //do subtraction
        temp = {divisor, 1'b0};            //subtract the divisor to get remainder and quotient
        
        c1 = ~{dividend, 1'b0} - temp[7:1];//subtract from dividend(absolute value) and shift left one bit
        c2 = temp[8:1] + cnt;                 //subtract divisor to get quotient (subtracted by carry-out)
        
		SR <= {temp, SR[7:0]};          //shift left one bit(remainder) and shift right 9 bits (quotient) into SR
    end
end
always@(posedge clk or negedge rst) begin : m2
    if(!rst) res_valid <= 0;
    else if (start_cnt == 8'b11111111 && cnt == 8'b11111111) //if the counter reaches 8, division is complete and will be restarted in next cycle
        res_valid <= 0;
    else if (start_cnt != 8'b11111111 && cnt != 8'b11111111) //if the counter does not reach 8, the register will be updated by subtraction result
        res_valid <= 1;
end
assign {result[7:0], result[15:8]} = SR; //shift left 8 bits for quotient and shift right 9 bits to get remainder in 16-bit format
always@(posedge clk or negedge rst) begin : m3
    if(!rst) res_ready <= 0;
    else res_ready <= ~opn_valid; //when opn_valid is high, res_ready will be low until operation is done and result will become valid to use
end

endmodule