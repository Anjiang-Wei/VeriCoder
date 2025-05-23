module JC_counter (
    input                       clk,
    input                        rst_n,
    output reg                    Q  
);

always @(posedge clk or negedge rst_n)
    if (!rst_n) Q <= 'd0;
    else if (~Q[0])  // If the MSB is a '1', then increment by shifting and appending a '1' to it
        Q <= {Q[63:1], ~Q[63:1]};
    else if (Q[0])   // If the MSB is a '0', then decrement by shifting and appending a '0' to it
        Q <= {Q[63:1], Q[63:1]};

endmodule