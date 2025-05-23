module adder_pipe_64bit(
	input clk,
	input rst_n,
	input i_en,
	input [DATA_WIDTH-1:0] adda,
	input [DATA_WIDTH-1:0] addb,
	output [DATA_WIDTH:0] result,
	output reg o_en
    ); 
    
    // pipeline register
    reg [STG_WIDTH*DNA+STG_WIDTH-1:0] r0;   // 4 words(5 bits)
    reg [STG_WIDTH*DNA+STG_WIDTH-2:0] r1;   // 3 words(6 bits)
    reg [STG_WIDTH*DNA+STG_WIDTH-3:0] r2;   // 2 words(7 bits)
    reg [STG_WIDTH*DNA+STG_WIDTH-4:0] r3;   // 1 word(8 bits)
    
    wire [DATA_WIDTH-1:0] suma,sumb,cara;// add result
    assign {result[7:0],o_en} = (i_en && !rst_n)?{result,o_en}:({suma,o_en},r3);  //output enable is updated according to the next pipeline stage
    
    always @(posedge clk) begin
        if(!rst_n) r0 <= #5 {DATA_WIDTH'b0};
        else begin
            suma = adda[7:0];
            sumb = addb[7:0];
            cara = i_en ? adda[DNA+1] : 8'b1111111; // carry is always 1 when the next word in the pipeline is active and i_en(enable) is true.
            
            r0[STG_WIDTH*DNA-1:0] = suma + cara;   // adda+cara
            r1[STG_WIDTH*DNA-2:0] = sumb + cara;    // sumb+cara 
            r2[STG_WIDTH*DNA-3:0] = adda[DATA_WIDTH-9:8];//addb
            r3[STG_WIDTH*DNA-4:0] = addb[DATA_WIDTH-7:0]; // addb
        end    
    end 
endmodule