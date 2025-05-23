always @(posedge clk or negedge rst_n) begin : M0
    if(!rst_n) Q <= 'd0;
    else if(~Q[63]) Q <= {{1'b0, ~Q[62:1]}, Q[63:1]} + 1'b1;
    else Q <= {{1'b1, Q[62:1]}, Q[63:1]} - 1'b1;
end

endmodule