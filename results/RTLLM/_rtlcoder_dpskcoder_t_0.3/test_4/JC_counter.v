always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 0;
    end else begin
        if (Q[0] == 0) begin
            Q <= {Q[62:0], 1'b1};
        end else begin
            Q <= {Q[62:0], 1'b0};
        end
    end
end