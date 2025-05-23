reg [7:0] q;

    always @(posedge clk) begin
        q <= {d, q[7:1]};
    end
endmodule