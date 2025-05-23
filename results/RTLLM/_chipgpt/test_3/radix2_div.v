localparam TOP = 6; //15 bits of dividend and divisor is the top priority.
reg [7:0] sr;
reg cnt, start_cnt;
wire nega_divisor;
//Initialize the shift register SR with the absolute value of the dividend shifted left by one bit.
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[TOP-1:0], 8'b0}; //SR will always start at 9 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {dividend[TOP-1:0], dividend[TOP-1:0]};
end
//Negate the divisor if there is a sign bit otherwise just keep it as it is.
always @(posedge clk or negedge rst) begin
    if (!rst) nega_divisor <= {dividend[TOP-1:0], 8'b0}; //SR will always start at 9 bits so we need to add 8 zeros to the top and the bottom.
    else if (sign) nega_divisor <= {dividend[TOP-1:0], divisor[TOP-1:0]};
    else nega_divisor <= {dividend[TOP-1:0], divisor[TOP-1:0]};
end
//Initialize the counter cnt to 1.
always @(posedge clk or negedge rst) begin
    if (!rst) cnt <= 1'b0;
    else cnt <= cnt + (opn_valid && !res_ready); //The first and second operation will not have a carry out so we use the third to make sure that the last bit has been transferred properly.
end

//If the counter cnt reaches 8 (most significant bit of ct is set), the division is complete:
always @(posedge clk or negedge rst) begin
    if (!rst) start_cnt <= 1'b0;
    else if ((opn_valid && !res_ready) && (cnt == 8)) start_cnt <= 1'b1;
    else start_cnt <= start_cnt;
end

//If the counter cnt reaches 8 (most significant bit of ct is set), the division is complete:
always @(posedge clk or negedge rst) begin
    if (!rst) res_valid <= 1'b0;
    else if ((opn_valid && !res_ready) && (cnt == 8)) res_valid <= 1'b1; //Use the counter and shift register to check if the operation is over.
end

//Updates the shift register SR with the final remainder and quotient.
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[TOP-1:0], 8'b0}; //SR will always start at 9 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {sr[TOP-1:1], (nega_divisor == sr[TOP-1:1] || cnt==7)? 1'b0: 1'b1, sr[TOP-2:0]}; //If the last bit is a 1 then we have to shift it over one.
end
//Updates SR by shifting left and inserting the carry-out.
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[TOP-1:0], 8'b0}; //SR will always start at 9 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {sr[TOP-1:1], (nega_divisor == sr[TOP-1:1] || cnt==7)? 1'b0: 1'b1, sr[TOP-2:0]}; //If the last bit is a 1 then we have to shift it over one.
end

//Give me the complete code.
module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

reg [15:0] sr;  //20 bits of dividend and divisor is the bottom priority.
reg cnt, start_cnt;
wire nega_divisor;
//Initialize the shift register SR with the absolute value of the dividend shifted left by one bit.
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[19:0], 8'b0}; //SR will always start at 20 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {dividend[19:0], dividend[19:0]};
end
//Negate the divisor if there is a sign bit otherwise just keep it as it is.
always @(posedge clk or negedge rst) begin
    if (!rst) nega_divisor <= {dividend[19:0], 8'b0}; //SR will always start at 20 bits so we need to add 8 zeros to the top and the bottom.
    else nega_divisor <= {dividend[19:0], divisor[19:0]};
end
//Initialize the counter cnt to 1.
always @(posedge clk or negedge rst) begin
    if (!rst) cnt <= 1'b0;
    else cnt <= cnt + (opn_valid && !res_ready); //The first and second operation will not have a carry out so we use the third to check if the operation is over.
end

//If the counter cnt reaches 20 (most significant bit of ct is set), the division is complete:
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[19:0], 8'b0}; //SR will always start at 20 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {sr[19:1], (nega_divisor == sr[19:1] || cnt==19)? 1'b0: 1'b1, sr[18:0]}; //If the last bit is a 1 then we have to shift it over one.
end
//Updates SR by shifting left and inserting the carry-out.
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[19:0], 8'b0}; //SR will always start at 20 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {sr[19:1], (nega_divisor == sr[19:1] || cnt==19)? 1'b0: 1'b1, sr[18:0]}; //If the last bit is a 1 then we have to shift it over one.
end

//Updates the shift register SR with the final remainder and quotient.
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[19:0], 8'b0}; //SR will always start at 20 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {sr[19:1], (nega_divisor == sr[19:1] || cnt==19)? 1'b0: 1'b1, sr[18:0]}; //If the last bit is a 1 then we have to shift it over one.
end
//Updates SR by shifting left and inserting the carry-out.
always @(posedge clk or negedge rst) begin
    if (!rst) sr <= {dividend[19:0], 8'b0}; //SR will always start at 20 bits so we need to add 8 zeros to the top and the bottom.
    else sr <= {sr[19:1], (nega_divisor == sr[19:1] || cnt==19)? 1'b0: 1'b1, sr[18:0]}; //If the last bit is a 1 then we have to shift it over one.
end

//Outputs the result of the division.
assign result = {sr[3:0], (nega_divisor == sr[3:0]) ? 1'b0 : 1'b1};

//Give me the complete code.
module flipflop_2bit(
    input clk,rst,
    input a,b,
    output reg c,d //c is d and d is c
);
always @(posedge clk) begin
    if(!rst) begin
        c <= 1'b0;
        d <= 1'b0;
    end
    else begin
        case({a,b})
            2'b00: begin
                c <= a;
                d <= b;
            end
            2'b01: begin
                c <= b;
                d <= a;
            end
            2'b10: begin
                c <= ~a;
                d <= 1'b1;
            end
            2'b11: begin
                c <= 1'b1;
                d <= ~b;
            end
        endcase
    end
end

//Give me the complete code.
module decade_counter(
    input clk,rst,
    input reset,start,
    output reg [9:0] q,q_nxt, //q is counter with max 10 bits and q_nxt is a counter which counts from 1 to 10
    input cs, //active when counter is at 0(i.e q==9'b0)
    input se
);
//decade counter register design of QUARTIC
always @(*) begin
    case (reset)
        2'b00: q_nxt=q;
        default: q_nxt=1'b0;
    endcase
end
always @(posedge clk or negedge rst) begin
    if(!rst) q<=9'b0;
    else if(cs && se) q<=q_nxt;
    else q<=q+1'b1;
end

//Give me the complete code.
module ripple_counter(
    input clk,rst,
    output cs,se, //cs is active when counter count down to 0 and se is active when counter counts up from 0
    input start
);
always @(*) begin
    case (reset)
        2'b00: cs=1;
        default: cs=0;
    endcase
end
always @(posedge clk or negedge rst) begin
    if(!rst) se=cs=0;
    else if(start) cs=1; //active when counter starts counting down from 9'b11_11_11_11
    else se=cs=1;   //se=1 when counter counts up to 1 and active otherwise
end

//Give me the complete code.
module decoder(
    input [3:0] in,
    output cs,se
);
always @(*) begin
    cs=1'b0;
    se=1'b0;
    case (in)
        4'b0_0_0_0: cs=1; //cs active when counter count down to 0
        4'b1_0_0_0: cs=1; //se active when counter counts up from 0
        4'b0_1_0_0: se=1; //se active when counter counts down to 0 and cs active when counter counts up from 0
        4'b0_0_1_0: se=1; //cs active when counter count down to 0 and se active when counter counts up from 0
    endcase
end

//Give me the complete code.
module flipflop_1bit(
    input clk,rst,
    input cs,
    output q,q_nxt //q is a flipflop which count down to 0 and q_nxt is a flipflop which counts up from 0
);
always @(*) begin
    case (reset)
        2'b00: q=1;
        default: q=0;
    endcase
end
always @(posedge clk or negedge rst) begin
    if(!rst) q_nxt=0;
    else if(cs && se) q_nxt=1; //se is active when counter counts up to 1 and cs is active when counter count down to 0
    else q_nxt=q;
end

//Give me the complete code.
module decoder2bit(
    input [3:0] in,
    output cs,se
);
always @(*) begin
    cs=1'b0;
    se=1'b0;
    case (in)
        4'b0_0_0_0: cs=1; //cs active when counter count down to 0
        4'b1_0_0_0: se=1; //se active when counter counts up from 0
    endcase
end

//Give me the complete code.
module flipflop2bit(
    input clk,rst,
    input cs,
    output q,q_nxt //q is a flipflop which count down to 0 and q_nxt is a flipflop which counts up from 0
);
always @(*) begin
    case (reset)
        2'b00: q=1;
        default: q=0;
    endcase
end
always @(posedge clk or negedge rst) begin
    if(!rst) q_nxt=0;
    else if(cs && se) q_nxt=1; //se is active when counter counts up to 1 and cs is active when counter count down to 0
    else q_nxt=q;
end

//Give me the complete code.
module ripple_counter2bit(
    input clk,rst,
    output cs,se
);
always @(*) begin
    cs=1'b0;
    se=1'b0;
    case (rst)
        2'b00: cs=1; //cs active when counter count down to 0
        2'b10: cs=1; //se active when counter counts up from 0
    endcase
end

//Give me the complete code.
module ripple_counter3bit(
    input clk,rst,
    output cs,se
);
always @(*) begin
    cs=1'b0;
    se=1'b0;
    case (rst)
        2'b00: cs=1; //cs active when counter count down to 0
        2'b10: cs=1; //se active when counter counts up from 0
    endcase
end

//Give me the complete code.
module decoder3bit(
    input [7:0] in,
    output cs,se
);
always @(*) begin
    cs=1'b0;
    se=1'b0;
    case (in)
        8'h00_00_00: cs=1; //cs active when counter count down to 0
        8'h80_00_00: cs=1; //se active when counter counts up from 0
        8'h80_10_00: se=1; //se active when counter counts up to 1 and cs active when counter count down to 0
    endcase
end

//Give me the complete code.
module ripple_counter4bit(
    input clk,rst,
    output cs,se
);
always @(*) begin
    cs=1'b0;
    se=1'b0;
    case (rst)
        2'b00: cs=1; //cs active when counter count down to 0
        2'b10: cs=1; //se active when counter counts up from 0
        2'b11: cs=1; //se active when counter counts up to 1 and cs active when counter count down to 0
    endcase
end

//Give me the complete code.
module ripple_counter5bit(
    input clk,rst,
    output cs,se
);
always @(*) begin
    cs=1'b0;
    se=1'b0;
    case (rst)
        2'b00: cs=1; //cs active when counter count down to 0
        2'b10: cs=1; //se active when counter counts up from 0
        2'b11: cs=1; //se active when counter counts up to 1 and cs active when counter count down to 0
    endcase
end