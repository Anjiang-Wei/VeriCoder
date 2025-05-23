module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg state;
reg [1:0] nxt_state;
reg pulsedone;
parameter IDLE = 2'b00,
          FIRST = 2'b01,
          SECOND = 2'b10,
          THIRD = 2'b11;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        state <= IDLE;
    else
        state <= nxt_state;
end

always @* begin
    data_out = 0;
    pulsedone = 1'b0;
    
    case (state)
        IDLE: begin
            if (data_in == 1)
                nxt_state <= FIRST;
            else
                nxt_state <= IDLE;
        end
        
        FIRST: begin
            if (data_out || data_in == 0)
                nxt_state <= SECOND;
            else
                pulsedone = 1'b1;
        end
        
        SECOND: begin
            if (data_out && data_in == 1)
                nxt_state <= THIRD;
            else
                nxt_state <= IDLE;
        end
        
        THIRD: begin
            if (pulsedone || data_in == 0)
                nxt_state <= IDLE;
            else
                nxt_state <= SECOND;
        end
    endcase
end

endmodule