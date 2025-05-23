wire [31:0] c;
reg [31:0] c_d; //d for delayed
parameter N = 256'd47;//for multiplication(47-bit) and accumulation(48-bit)
always @(*)
begin
c_d = a*b;  
c = c_d[N:0];
end
endmodule