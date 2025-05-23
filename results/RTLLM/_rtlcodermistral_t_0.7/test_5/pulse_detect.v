développer ici ....
Ďâìè 4 états: 
``` verilog
    parameter IDLE = 2'b00;
    parameter P1 = 2'b01;
    parameter P2 = 2'b10;
    parameter P3 = 2'b11;
```
 initial state est IDLE: data_out = 0
``` verilog
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 0;    
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin              
                    if (data_in) begin  
                        state <= P1;
                    end 
                end 
                P1: begin
                    if (data_in) begin
                        state <= P2;
                    end
                    else begin
                        state <= IDLE;
                    end 
                end
                P2: begin
                    if (~data_in) begin
                        state <= P3;
                    end
                    else begin
                        state <= P1;
                    end 
                end
                P3: begin
                    data_out <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule