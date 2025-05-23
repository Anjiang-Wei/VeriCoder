module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
    input CLK_in, RST;
    output reg CLK_50, CLK_10, CLK_1;
    
    reg [3:0] cnt_10;  // Counter for 10MHz
    reg [6:0] cnt_100; // Counter for 1MHz
    reg CLK_in_d;      // One-cycle delay for CLK_in

    // Combinational logic to generate CLK_50
    always @(*) begin
        CLK_50 = RST ? 0 : !CLK_50;
    end

    // Combinational logic to generate CLK_10
    always @(*) begin
        if (RST) begin
            CLK_10 = 0;
            cnt_10 = 4'd0;
        end else if (cnt_10 == 4'd4) begin
            CLK_10 = !CLK_10;
            cnt_10 = 4'd0;
        end else begin
            cnt_10 = cnt_10 + 1'b1;
        end
    end

    // Combinational logic to generate CLK_1
    always @(*) begin
        if (RST) begin
            CLK_1 = 0;
            cnt_100 = 7'd0;
        end else if (cnt_100 == 7'd49) begin
            CLK_1 = !CLK_1;
            cnt_100 = 7'd0;
        end else begin
            cnt_100 = cnt_100 + 1'b1;
        end
    end

    // Sequential logic to handle the input clock and reset
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            CLK_50 <= CLK_50;
            CLK_10 <= CLK_10;
            CLK_1 <= CLK_1;
        end
    end

    // One-cycle delay for CLK_in
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_in_d <= 0;
        else
            CLK_in_d <= CLK_in;
    end

endmodule