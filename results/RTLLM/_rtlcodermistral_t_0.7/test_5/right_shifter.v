```verilog
    reg [7:0] q;  
    always @(posedge clk) begin
        q <= {q[6:0], d};
    end
endmodule