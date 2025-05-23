always @(posedge clk)
    if (~rst_n && !valid_count) {
        out <= 4'b0000;
    }
    else if (valid_count && ~{out, {3'd11,1'b1}}) {
        out <= 4'b0000;
    }
    else if (!valid_count) {
        out <= out + 1'b1;
    }
    else {
        out <= out;
    }

endmodule