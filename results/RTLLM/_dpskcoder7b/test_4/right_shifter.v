always @(posedge clk) begin  
        q <= {d, q[7:1]}; 
    end  
endmodule