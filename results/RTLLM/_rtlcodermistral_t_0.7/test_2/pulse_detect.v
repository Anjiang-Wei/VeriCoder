bekanntes Zustandsautomat:
``` verilog
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
```
Reg to keep track of current state:
``` verilog
reg [1:0] state, next_state; 
```
``` verilog
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
 begin
      state <= S0;
      data_out <= 1'b0;
  end
    else begin
      state <= next_state;
    end
end
```
Logic to generate next state:
``` verilog
always @*
begin
    case(state)
        S0:
            if (data_in) begin
                next_state = S1;
            end
            else begin
                next_state = S0;
            end
        S1:
            if (data_in) begin
                next_state = S2;
            end
            else begin
                next_state = S0;
            end
        S2:
            if (data_in) begin
                next_state = S3;
                data_out <= 1'b1;
            end
            else begin
                next_state = S0;
                data_out <= 1'b0;
            end
        S3:
            if (~data_in) begin
                next_state = S0;
                data_out <= 1'b0;
            end
            else begin
                next_state = S3;
            end
    endcase
end
```
 End of module:
``` verilog
Endmodule