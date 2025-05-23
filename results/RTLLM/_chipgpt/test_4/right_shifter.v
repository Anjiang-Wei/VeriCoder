module register_file(clk,q[7:0],d[7:0]);  //use mimo215 register file to implement the shift operation.
    input clk; //clock signal used for synchronous operation.
    input d[7:0];//input bit to be shifted.
    output q[7:0];//output 8-bit value after left shifting and right-shifting.

    reg [7:0] q;
    
    always @(posedge clk) //left shifter
    begin
        q <= {q[6:0],d};  
    end  
  
    always @(posedge clk) //right shifter
    begin
        q <= (q >> 1);  
        q[7] <= d;
    end

endmodule