reg [31:0] c;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c <= 0;
    end else begin
        c <= c + (a * b);
    end
end