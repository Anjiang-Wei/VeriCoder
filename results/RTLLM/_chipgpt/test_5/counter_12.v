always @(posedge clk)
    if (rst_n) out <= 4'b0000;
    else if (valid_count && ~out[3]) out <= {out, out[3] + 1'b1};
    else out <= out;   // Wrap around and reset if the count reaches 11

endmodule