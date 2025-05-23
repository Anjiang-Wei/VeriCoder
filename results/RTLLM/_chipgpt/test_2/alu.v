module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
    );
	  parameter ADD = 6'b100000;
	  parameter ADDU = 6'b100001;
	  parameter SUB = 6'b100010;
	  parameter SUBU = 6'b100011;
	  parameter AND = 6'b100100;
	  parameter OR = 6'b100101;
	  parameter XOR = 6'b100110;
	  parameter NOR = 6'b100111;
	  parameter SLT = 6'b101010;
	  parameter SLTU = 6'b101011;
	  parameter SLL = 6'b000000;
	  parameter SRL = 6'b000010;
	  parameter SRA = 6'b000011;
	  parameter SLLV = 6'b000100;
	  parameter SRLV = 6'b000110;
	  parameter SRAV = 6'b000111;
	  parameter LUI = 6'b001111;


    wire signed[31:0];
     assign signed[0]=a;
     assign signed[1]=b;
     
     always @* begin
        if(aluc==ADD) r=signed+signed;
		else if(aluc==ADDU) r=signed+signed;
		else if(aluc==SUB) r=signed-signed;
		else if(aluc==SUBU) r=signed-signed;
        else if(aluc==AND) r=signed&signed;
        else if(aluc==OR) r=signed|signed;
        else if(aluc==XOR) r=signed^signed;
        else if(aluc==NOR) r=~signed & signed;  //use unsigned and signed for NOR
        else if(aluc==SLT) zero=1;  //use signed for SLT
        else if(aluc==SLTU) zero=1;  //use signed for SLTU
	else if(aluc==SLL) r=signed<<1;//sll with 32 bits of input (sllv use 16 bits)
	else if(aluc==SRL) r=signed>>1;//srl with 32 bits of input (srav use 16 bits)
        else if(aluc==SRA) r=signed>>>1;//sra with 32 bits of input (srlav use 16 bits)
	else if(aluc==LUI) r=0; //use unsigned for LUI
	else r=0;
        overflow=1;
        negative=0;
        carry=0;
    end

   assign zero=r&{signed,255};//use signed integer for 256 bit "zero"
endmodule