localparam NEG_DIVISOR = -1;
reg [7:0] cnt;
reg [3:0] start_cnt;
reg SR;
reg hex_dividend;
reg hex_divisor;
reg opn_valid_next;
reg res_ready_next;

//input signal declarations
input wire clk,
    rst,
    sign[1],
    dividend[7:0],     //7-bit unsigned
    divisor[7:0];      //8-bit unsigned or 8-bit signed (sign)

//output register declarations
reg [7:0] SR;
reg res_valid,res_ready;
reg result[15:0];

//FSM declarations(2 states and 6 transition conditions)
reg start_tick_nxt; //1-bit output for start/stop operation of the 32-bit divider logic
reg start_cnt_nxt; //counter used to count up to 8 bits. The counter is used as a 8-bit shift register with the absolute value of dividend(SR) left shifted by one bit
always @(*)
    case({opn_valid,res_ready})
        2'b00: start_tick_nxt=1'b0;
        2'b01: start_tick_nxt=start_cnt_nxt;
        2'b10: start_tick_nxt = 1'b0; //stop operation of the divider
        2'b11: start_tick_nxt=1'b1;//start operation of the divider
    endcase
assign res_valid=(opn_valid && !res_ready); //1-bit output to indicate whether the result is valid and ready for consumption. When 1, it indicates that a valid operation request is present
always @(posedge clk)
    if (rst) start_tick_nxt <= 1'b0;
    else start_tick_nxt<=start_tick_nxt_nxt;
always @(posedge clk)
    if (rst) start_cnt_nxt <= 8'd255;
    else if (opn_valid && res_ready) start_cnt_nxt<=start_cnt_nxt_nxt;
    else start_cnt_nxt<=start_tick_nxt;
always @(posedge clk,reset) begin
    SR <= 8'd0;
    cnt <= 8'd0;
    hex_divisor <= 8'b0;
    hex_dividend <= 8'b0;
    start_cnt <= 8'd0;
    res_ready <= 1'b0;
    opn_valid_next <= 1'b0;
    res_valid <= 1'b0;
end
//SR register operation logic(16-bit)
always @* begin
    hex_divisor = -1; //Negative divisor when signed division is required.
    hex_dividend = ~dividend;
    res_ready <= 1'b0;
    opn_valid_next <= 1'b0;
    
    case({hex_divisor,hex_dividend}) //subtraction of the divisor from dividend(SR) to get a remainder and quotient. 
        2'b01: begin
            if (start_cnt == 8) //division complete
                SR <= hex_dividend;
            else if (start_cnt != 8) begin
                hex_dividend <= hex_dividend - hex_divisor;
                SR <= SR << 1;
                start_cnt <= cnt + 1;
                res_ready <= 1'b1; //signal to indicate the result is valid and ready for consumption. This signals that the next bit of dividend(SR) will be used as a quotient or remainder. 
            end
        end
        2'b10: begin //case of negative divisor, hex_dividend must be a positive number. In this case, hex_divisor is set to -1 and the subtraction logic for hex_dividend will work properly(hex_dividend-hex_divisor will always have an unsigned remainder)
            if (start_cnt == 8) //division complete
                SR <= hex_dividend;
            else if (start_cnt != 8) begin
                hex_dividend <= hex_dividend - hex_divisor;
                SR <= SR << 1;
                start_cnt <= cnt + 1;
                res_ready <= 1'b1; //signal to indicate the result is valid and ready for consumption. This signals that the next bit of dividend(SR) will be used as a quotient or remainder. 
            end
        end
    endcase
end
//FSM state declarations(2 states)
reg start_tick,start_cnt; //registers to count up to 8 bits and use as a 8-bit shift register with the absolute value of dividend(SR) left shifted by one bit.
always @* begin
    start_tick = 1'b0;
    start_cnt <= 8'd0;
    
case({opn_valid,res_ready})
        2'b00: //start operation of the divider, start_tick will be 1'b1 until stopped.
            if (rst) start_tick = 1'b0;
        else if (!start_tick && !res_ready) start_tick = 1'b1;
        else start_tick = start_tick_nxt; //signal to stop the divider, start_tick will be reset to 1'b0.
    
    case(start_tick)
        1'b0: begin
            if (rst) start_cnt <= 8'd255;
        else if (!start_tick && !res_ready) start_cnt <= 8'd255; //signal to stop the divider, start_cnt will be reset to 0. 
        else if (opn_valid && res_ready) start_cnt <= cnt + 1; //next bit of dividend(SR) is used as a quotient or remainder
        end
    endcase
end
//signal declaration for the divider operation logic and stop operation
wire [8:0] hex_divisor,hex_dividend; //hexadecimal number representing the divisor and dividend
reg start_tick; //register to signal the start of the divider operation. 1'b0 to start divider and 1'b1 to stop divider.
always @* begin
    hex_divisor = 8'd0;
    hex_dividend = 8'd0;
    
case({hex_divisor,hex_dividend}) //signal for the operation of the divider and stop operation
        2'b01: begin
            if (start_tick == 1'b1) begin
                hex_divisor = hex_divisor - 8'd1; //stop operation, hex_divisor will be -ve.
                start_tick <= 1'b0; //signal to stop the divider
            end
        end
        2'b10: begin
            if (start_tick == 1'b1) begin
                hex_dividend = hex_divisor - hex_dividend; //stop operation, hex_divisor will be -ve.
                start_tick <= 1'b0; //signal to stop the divider
            end
        end
    endcase
end
endmodule