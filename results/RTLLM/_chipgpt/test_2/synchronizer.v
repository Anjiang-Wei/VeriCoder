module register(
    input clk_a, 
    input arstn,
    input[3:0] data_in,
    input data_en,

    output reg[3:0] data_reg   //register storing the last value of the data input signal(data_in)
);
//on reset signal(arstn), register will be initialized to 0 or the last value of the register.
always @(posedge clk_a or negedge arstn)
begin
    if(!arstn) begin
        data_reg<=0;
    end
    else begin
        if(data_en) data_reg<=data_in;  //if the enable signal is HIGH, register will store the value of input signal.
    end    
end
endmodule