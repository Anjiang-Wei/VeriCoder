wire [3:0] state;
parameter IDLE = 4'b0000,
            WAITING = 4'b0001,
            ONE = 4'b0010,
            ZERO = 4'b0011;

reg [3:0] state_nxt, state_future;
parameter INIT = 5'b0000_0000,
             WAITING = 5'b0000_0001,
             ONE = 5'b0000_0010,
             ZERO = 5'b0000_0011;

//output data_out is active low
always @(posedge clk) begin
    if (~rst_n) state <= INIT;
    else state <= state_future;
end

//register used to keep track of the current state, which will be used in the future states
always @* begin //use always @* instead of normal always @(*) for faster performance(from Digital Design by Morris Mano)
    state_nxt = state;
    case (state)
        INIT: 
            if (data_in == 1'b0) state_nxt = WAITING; //waiting for the next pulse, when "data_in" changes from 0 to 1(last cycle), it will be considered as a "pulse". In this case, the "pulse" is "01", and since there's only one bit that flipped, therefore the number of cycles must be even. Hence state_nxt = WAITING
        WAITING: 
            if (data_in == 1'b1) state_future = ZERO; //when "data_in" changes from 0 to 1(last cycle), it will be considered as a "pulse". In this case, the "pulse" is "01", and since there's only one bit that flipped, therefore the number of cycles must be even. Hence state_nxt = ZERO
        ONE: 
            if (data_in == 1'b0) state_future = WAITING; //when "data_in" changes from 1 to 0(last cycle), it will be considered as a "pulse". In this case, the "pulse" is "10", and since there's only one bit that flipped, therefore the number of cycles must be even. Hence state_future = WAITING
        ZERO: 
            if (data_in == 1'b1) state_next = ONE; //when "data_in" changes from 0 to 1(last cycle), it will be considered as a "pulse". In this case, the "pulse" is "01", and since there's only one bit that flipped, therefore the number of cycles must be even. Hence state_next = ONE
        default: state_nxt = INIT;
    endcase 
end

always @* begin //use always @* instead of normal always @(*) for faster performance(from Digital Design by Morris Mano)
    data_out = 1'b0;
    case (state)
        WAITING: 
            if (data_in == 1'b1 && state_future == ZERO) begin //if the "pulse" is even, it will be considered as a pulse, so here the number of cycles must be even to ensure that there is one bit flipped(from MOSI to MISO). In this case, the "pulse" is "01", and since there's only one bit that flipped, therefore the number of cycles must be even
                data_out = 1'b1;
            end
        ONE: begin //when "data_in" changes from 1 to 0(last cycle), it will be considered as a pulse. In this case, the "pulse" is "10", and since there's only one bit that flipped, therefore the number of cycles must be even
                data_out = 1'b1;
            end
        ZERO: begin //when "data_in" changes from 0 to 1(last cycle), it will be considered as a pulse. In this case, the "pulse" is "01", and since there's only one bit that flipped, therefore the number of cycles must be even
                data_out = 1'b1;
        default: data_out = 1'b0;
    endcase 
end

endmodule