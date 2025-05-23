module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

    // Internal signals
    reg [3:0] data;
    reg [1:0] cnt;
    reg valid;

    // Assign dout to the MSB of data
    assign dout = data[3];

    // Assign valid_out to valid
    assign valid_out = valid;

    // Reset logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'b0;
            cnt <= 2'b0;
            valid <= 1'b0;
        end else begin
            // Update data and reset cnt when cnt is 3
            if (cnt == 3) begin
                data <= d;
                cnt <= 2'b0;
                valid <= 1'b1;
            end else begin
                // Shift data left and increment cnt
                data <= {data[2:0], data[3]};
                cnt <= cnt + 1;
                valid <= 1'b0;
            end
        end
    end

endmodule