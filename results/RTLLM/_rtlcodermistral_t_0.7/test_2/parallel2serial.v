module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        data <= 4'b0;
        valid_out <= 1'b0;
    end else begin
        if (cnt == 2'b00) begin
            data <= d;
            cnt <= 2'b01;
            valid_out <= 1'b1;
        end else if (cnt == 2'b01) begin
            dout <= data[3];
            cnt <= 2'b10;
            valid_out <= 1'b1;
        end else if (cnt == 2'b10) begin
            dout <= data[2];
            cnt <= 2'b11;
            valid_out <= 1'b1;
        end else if (cnt == 2'b11) begin
            dout <= data[1];
            cnt <= 2'b00;
            valid_out <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            valid_out <= 1'b0;
        end
    end
end

endmodule