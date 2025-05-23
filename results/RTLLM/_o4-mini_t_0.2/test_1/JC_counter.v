module JC_counter(
    input        clk,    // system clock
    input        rst_n,  // active‑low reset
    output reg [63:0] Q  // 64‑bit Johnson counter state
);

    // On reset (rst_n low) clear Q.  Otherwise shift right,
    // and append the inverted LSB at the MSB position.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;
        end else begin
            // If Q[0]==0, append 1; if Q[0]==1, append 0.
            Q <= { ~Q[0], Q[63:1] };
        end
    end

endmodule