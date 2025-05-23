module edge_detect(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // delayed version of 'a' for edge comparison
    reg a_d;

    // sample 'a' and generate one‐cycle pulses for rising/falling edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // capture previous state
            a_d <= a;

            // detect edges
            rise <=  a & ~a_d;   // high when a transitions 0->1
            down <= ~a &  a_d;   // high when a transitions 1->0
        end
    end

endmodule