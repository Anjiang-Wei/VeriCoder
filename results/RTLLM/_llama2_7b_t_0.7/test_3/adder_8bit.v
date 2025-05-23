module adder_8bit(
    input [7:0] a, b, 
    input cin, 
    output [7:0] sum, 
    output cout);

// Bit-level adders for each bit of the output
always @(*)
begin
    case (a)
        8'h00: sum <= b;
        8'h01: sum <= a + b;
        8'h10: sum <= a + cin;
        8'h11: sum <= a + b + cin;
        default: sum <= 0;
    endcase
end

// Carry-out generator
always @(*)
begin
    case (a)
        8'h00: cout <= 0;
        8'h01: cout <= cin;
        8'h10: cout <= a + b + cin;
        8'h11: cout <= a + b;
        default: cout <= 0;
    endcase
end

// Connect the adders and carry-out generator to the output pins
assign sum = adder(a, b);
assign cout = carry_out(a, b, cin);