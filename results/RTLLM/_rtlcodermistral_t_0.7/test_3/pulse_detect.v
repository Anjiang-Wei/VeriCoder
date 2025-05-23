ポア・リス」
以下的注解是我自己猜测的，和原作者的意思可能有差距，大家可以自行理解~

```Verilog
always @(posedge clk, negedge rst_n) begin    
    if (~rst_n) begin        // 重置条件
        data_out <= 0;         
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                if (data_in == 1) begin
                    state <= PULSE;
                end
            end
            PULSE: begin
                if (data_in == 0) begin
                    state <= IDLE;
                    data_out <= 1;
                end
            end
        endcase
    end
end
```

注意：state和data_in的取值范围，可以根据实际需求进行定义，比如PULSE1, PULSE2, PULSE3, PULSE4, PULSE5, PULSE6, PULSE7，data_in可以取值为0,1,2,3,4,5,6，而state可以取值为PULSE1, PULSE2, PULSE3, PULSE4, PULSE5, PULSE6, PULSE7。

State machine :

IDLE  : 0
PULSE : 1

Data_in :
0 : 00000
1 : 00001
2 : 00010
3 : 00011
4 : 00100
5 : 00101
6 : 00110

当data_in的值从0->1->0时，就认为是一个pulse，所以data_out的值为pulse的最后一次data_in的值（data_in的最后一次值为1，dataout的值为1）。

当data_in的值为0时，dataout的值为0。

State machine :

IDLE : 00000
PULSE : 00001

dataout : 00001

当data_in的值为1时，state的值会变为PULSE，dataout的值会变为1，这时，data_in的值为0， state的值变回到 IDLE，dataout的值变回到 0。

当data_in的值为2，3，4，5，6时，state的值会变为 PULSE，dataout的值会变为 0。

 Endianess : big endian

 Endianess : big endian

// state machine
parameter IDLE = 2'b00;
parameter PULSE = 2'b01;

// data_in
parameter DATA_IN_0 = 2'b00;
parameter DATA_IN_1 = 2'b01;
parameter DATA_IN_2 = 2'b10;
parameter DATA_IN_3 = 2'b11;
parameter DATA_IN_4 = 2'b100;
parameter DATA_IN_5 = 2'b101;
parameter DATA_IN_6 = 2'b110;

// data_out
reg data_out;

// state
reg [1:0] state;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data_in == DATA_IN_1) begin
                    state <= PULSE;
                end
            end
            PULSE: begin
                if (data_in == DATA_IN_0) begin
                    state <= IDLE;
                    data_out <= 1;
                end
            end
        endcase
    end
end

endmodule