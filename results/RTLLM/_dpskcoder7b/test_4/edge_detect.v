reg pre_a;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pre_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        pre_a <= a;
        if(a && !pre_a)
            rise <= 1'b1;
        else if(!a && pre_a)
            down <= 1'b1;
        else 
            rise <= 1'b0;
            down <= 1'b0;
    end
end
endmodule