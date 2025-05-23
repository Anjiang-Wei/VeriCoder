// Counter Register
reg [1:0] cnt;

// Data Register
reg [3:0] data;

// Valid Register
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        valid <= 1'b0;
        data <= 4'b0000;
    end
    else begin
        if (cnt == 2'b11) begin
            data <= d;
            cnt <= 2'b00;
            valid <= 1'b1;
        end
        else begin
            cnt <= cnt + 1;
            valid <= 1'b0;
            data <= {data[2:0], d[3]};
        end
    end
end

assign valid_out = valid;
assign dout = data[3];

endmodule