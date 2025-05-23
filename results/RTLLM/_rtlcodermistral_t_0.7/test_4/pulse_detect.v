 states description:
```
    State 0: data_in is 0, waiting for data_in to change to 1
    State 1: data_in is 1, waiting for data_in to change back to 0
    State 2: data_in is 0, waiting for data_in to change to 1
`` así, suceden 3 ciclos, y se produce un pulso.
```

 states register:
```
    reg [1:0], state;    
    parameter State0 = 2'b00, State1 = 2'b01, State2 = 2'b10;    
    always @(posedge clk or negedge rst_n) begin    
        if (~rst_n) begin    
            state <= State0;
            data_out <= 1'b0;
        end    
        else begin    
            case (state)    
                State0: begin    
                    if (data_in == 1'b1)    
                        state <= State1;    
                end    
                State1: begin    
                    if (data_in == 1'b0)    
                        state <= State2;    
                        data_out <= 1'b1;    
                end    
                State2: begin    
                    if (data_in == 1'b1)    
                        state <= State0;    
                end    
            endcase    
        end    
    end    
endmodule