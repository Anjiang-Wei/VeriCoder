module verified_right_shifter(clk,q,d);
    reg [7:0] q;
    input clk,d;
    output[7:0] q;

    always@(posedge clk) begin  //use @ for verilog-2001 compliance
        if(!empty) q <= {q[6:0],d};  
        else q <= (q >> 1);     
    end 
    
endmodule