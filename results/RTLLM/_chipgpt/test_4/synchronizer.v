module data_reg(
    input clk_a,
    input arstn,
    input en,
    input [3:0] in,
    
    output reg [3:0] q
); 

// use tri-state buffer to make sure the input will be kept stable after reset.
// also ensure that the register is not cleared unless it has been written.
always @(posedge clk_a or negedge arstn) 
    if(!arstn) q <= 0; // no write without a read operation.
    else if(en && in != q) q <= in; // data input will be written to the register only when "en" is high and the content of the register has not changed yet.

endmodule