module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output reg dout
);
    reg [1:0] cnt;
    reg [3:0] data;

    // Counter Register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            cnt <= 2'b00;
        end else begin
            cnt <= cnt + 1;
        end
    end

    // Parallel-to-Serial Conversion
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            valid_out <= 1'b0;
            data <= 4'b0000;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                valid_out <= 1'b1;
                data <= d;
                dout <= d[3];
            end else if (cnt == 2'b10) begin
                valid_out <= 1'b1;
                dout <= d[2];
            end else if (cnt == 2'b01) begin
                valid_out <= 1'b1;
                dout <= d[1];
            end else if (cnt == 2'b00) begin
                valid_out <= 1'b1;
                dout <= d[0];
            end else begin
                valid_out <= 1'b0;
                dout <= 1'b0;
            end
        end
    end
endmodule