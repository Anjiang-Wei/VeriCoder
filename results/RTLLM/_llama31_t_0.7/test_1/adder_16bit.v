module adder_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] y,
    output wire Co
);
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    assign y[1] = a[1] ^ b[1] ^ Co;
    assign Co = (a[1] & b[1]) | (a[1] & Co) | (b[1] & Co);

    assign y[2] = a[2] ^ b[2] ^ Co;
    assign Co = (a[2] & b[2]) | (a[2] & Co) | (b[2] & Co);

    assign y[3] = a[3] ^ b[3] ^ Co;
    assign Co = (a[3] & b[3]) | (a[3] & Co) | (b[3] & Co);

    assign y[4] = a[4] ^ b[4] ^ Co;
    assign Co = (a[4] & b[4]) | (a[4] & Co) | (b[4] & Co);

    assign y[5] = a[5] ^ b[5] ^ Co;
    assign Co = (a[5] & b[5]) | (a[5] & Co) | (b[5] & Co);

    assign y[6] = a[6] ^ b[6] ^ Co;
    assign Co = (a[6] & b[6]) | (a[6] & Co) | (b[6] & Co);

    assign y[7] = a[7] ^ b[7] ^ Co;
endmodule

module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] y,
    output wire Co
);
    reg signed [7:0] tmp_y1, tmp_y2;
    
    // First half of 16-bit adder
    assign {tmp_y2[7], tmp_y2[6:0]} = adder_8bit(.a(a[15:8]), .b(b[15:8]), .Cin(Cin), .y(tmp_y1), .Co(Co));
    
    // Second half of 16-bit adder
    assign {tmp_y1[7], tmp_y1[6:0]} = adder_8bit(.a(a[7:0]), .b(b[7:0]), .Cin(tmp_y2[7] | Co), .y(y[15:8]), .Co(Co));
endmodule