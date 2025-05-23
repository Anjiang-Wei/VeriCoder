```verilog
reg [3:0] data;
reg [1:0] cnt;

assign valid_out = cnt == 2'b11;
assign dout = data[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 2'b00;
        data <= 4'b0000;
    end
    else begin
        if (cnt == 2'b11) begin
            data <= d;
            cnt <= 2'b00;
        end
        else begin
            cnt <= cnt + 1;
            data <= {data[2:0], d[3]};
        end
    end
end

endmodule