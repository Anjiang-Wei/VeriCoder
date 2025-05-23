module register_with_enable(
    input clk,
    input rst_n,
    input en, 
    input [7:0] in,
    output out
);

reg [3:0] reg_en;
reg [15:0] reg_out;
initial begin
    reg[1:0] temp = {2'b00, in}; //store one bit of input for each register
    reg[7:0] temp_en = {8{1'b1}};  //store the enable signal for all registers

    reg_en <= temp;
    reg_out <= temp_en;
end
always @(posedge clk) begin
    if (rst_n) reg_en <= 0;  
    else reg_en <= reg_en;      //use "flip-flop" style for enable register
    if (en) reg_out <= in;
end
//register "reg_out" is used to store the sum of partial products
always @(posedge clk) begin
    if (rst_n) 
        out <= 0;   //use "flip-flop" style for output register
    else if (en && !(in == 8'd0))  //register is active and the input value is different from zero
        out <= reg_out + {reg[15:8] {1'b1, in}};   //store sum of partial products to output register
end

endmodule