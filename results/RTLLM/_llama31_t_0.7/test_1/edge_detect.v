module edge_detect(
    input clk,
    input rst_n,
    input a,

    output reg rise,
    output reg down
);
    // Register for storing previous value of signal 'a'
    reg prev_a;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            begin
                rise <= 0;
                down <= 0;
                prev_a <= 1'b0;  // Reset to zero on active-low reset
            end
        else
            begin
                prev_a <= a;
            end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rise <= 0;
        else
            rise <= (a && !prev_a);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            down <= 0;
        else
            down <= ((!a) && prev_a);
    end
endmodule // edge_detect