// Write your Verilog code here
reg [3:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'b0;
        sum <= 10'b0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            if (counter < 4'b1000) begin
                sum <= sum + data_in;
                counter <= counter + 1'b1;
            end
            if (counter == 4'b1000) begin
                data_out <= sum;
                valid_out <= 1'b1;
                counter <= 4'b0;
                sum <= 10'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end
endmodule