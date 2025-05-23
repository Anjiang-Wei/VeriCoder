reg a_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        a_reg <= a;
        if (a_reg && !a) begin
            down <= 1'b1;
        end else if (!a_reg && a) begin
            rise <= 1'b1;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end
endmodule