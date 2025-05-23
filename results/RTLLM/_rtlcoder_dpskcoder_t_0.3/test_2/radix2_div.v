```verilog
reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] ABS_DIVIDEND;
reg [7:0] ABS_DIVISOR;
reg [7:0] SUB_RESULT;
reg [7:0] CARRY_OUT;
reg [7:0] NEG_CARRY_OUT;
reg [7:0] NEG_RESULT;
reg [7:0] QUOTIENT;
reg [7:0] REMAINDER;

always @(*) begin
    if (sign == 1) begin
        ABS_DIVIDEND = dividend[7] ? -dividend : dividend;
        ABS_DIVISOR = divisor[7] ? -divisor : divisor;
    end else begin
        ABS_DIVIDEND = dividend;
        ABS_DIVISOR = divisor;
    end
end

always @(*) begin
    if (sign == 1) begin
        NEG_DIVISOR = ABS_DIVISOR[7] ? -ABS_DIVISOR : ABS_DIVISOR;
    end else begin
        NEG_DIVISOR = ABS_DIVISOR;
    end
end

always @(posedge clk) begin
    if (rst) begin
        SR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            SR <= {ABS_DIVIDEND, 1'b0};
            cnt <= 3'b1;
            start_cnt <= 1'b1;
        end else if (start_cnt) begin
            if (cnt == 3'b111) begin
                cnt <= 3'b0;
                start_cnt <= 1'b0;
                SR <= {REMAINDER, QUOTIENT};
                res_valid <= 1'b1;
            end else begin
                cnt <= cnt + 1;
                SUB_RESULT = SR[7:0] - NEG_DIVISOR;
                CARRY_OUT = (SR[7] && NEG_DIVISOR[7]) || (!SR[7] && !NEG_DIVISOR[7]);
                NEG_CARRY_OUT = !CARRY_OUT;
                NEG_RESULT = SUB_RESULT[7] ? -SUB_RESULT : SUB_RESULT;
                if (CARRY_OUT) begin
                    SR <= {NEG_CARRY_OUT, SR[7:1]};
                end else begin
                    SR <= {NEG_CARRY_OUT, SR[7:1]};
                end
            end
        end
    end
end

always @(*) begin
    if (sign == 1) begin
        QUOTIENT = SR[15:8];
        REMAINDER = SR[7:0];
    end else begin
        QUOTIENT = SR[15:8];
        REMAINDER = SR[7:0];
    end
end

assign result = {REMAINDER, QUOTIENT};

endmodulemodule top_module(
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

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] ABS_DIVIDEND;
reg [7:0] ABS_DIVISOR;
reg [7:0] SUB_RESULT;
reg [7:0] CARRY_OUT;
reg [7:0] NEG_