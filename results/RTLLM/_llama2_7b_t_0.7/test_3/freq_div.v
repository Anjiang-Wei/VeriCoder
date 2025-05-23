module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
input CLK_in; // input clock signal
input RST; // reset signal
output reg CLK_50; // output clock signal with a frequency of CLK_in divided by 2
output reg CLK_10; // output clock signal with a frequency of CLK_in divided by 10
output reg CLK_1; // output clock signal with a frequency of CLK_in divided by 100

// counter structures
wire [3:0] cnt_50; // counter for CLK_50 generation
wire [3:0] cnt_10; // counter for CLK_10 generation
wire [3:0] cnt_1; // counter for CLK_1 generation

// assignment and logic
assign CLK_50 = (RST == 0) ? ~CLK_in : 0; // set CLK_50 to 0 when RST is active
assign CLK_10 = (RST == 0) ? ~CLK_in : 0; // set CLK_10 to 0 when RST is active
assign CLK_1 = (RST == 0) ? ~CLK_in : 0; // set CLK_1 to 0 when RST is active

always@(posedge CLK_in or negedge RST) begin
    // CLK_50 generation
    if (!RST) begin
        cnt_50 <= 0;
        CLK_50 <= ~CLK_in;
    end else begin
        cnt_50 <= cnt_50 + 1;
        if (cnt_50 == 4) begin
            cnt_50 <= 0;
            CLK_50 <= ~CLK_in;
        end
    end

    // CLK_10 generation
    if (!RST) begin
        cnt_10 <= 0;
        CLK_10 <= ~CLK_in;
    end else begin
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_in;
        end
    end

    // CLK_1 generation
    if (!RST) begin
        cnt_1 <= 0;
        CLK_1 <= ~CLK_in;
    end else begin
        cnt_1 <= cnt_1 + 1;
        if (cnt_1 == 49) begin
            cnt_1 <= 0;
            CLK_1 <= ~CLK_in;
        end
    end
end