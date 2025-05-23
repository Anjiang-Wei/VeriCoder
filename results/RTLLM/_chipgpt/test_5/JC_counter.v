initial begin : init
   $display("The value of Q is %d",Q)
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        Q <= 0;
    else if(~Q[63]) //if the most significant bit is '1' then decrement
        Q<= {~{Q[62:1]},Q[63:1]}; 
    else if(Q[63])//if the least significent bit is '0',then increment
        Q <= {Q[62:1],~Q[63]};  
end

endmodule