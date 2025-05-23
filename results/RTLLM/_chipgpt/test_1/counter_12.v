always @(posedge clk) begin
    if (!rst_n) out <= 4'b0000;
    else if (valid_count && !out[3]) out <= out + 1'b1;
    else if (out == 4'd11) out <= 4'b0000;
end

endmodule