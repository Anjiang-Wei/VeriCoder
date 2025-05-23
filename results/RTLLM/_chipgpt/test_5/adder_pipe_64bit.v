module pipeline(
	input clk,rst_n,
	input i_en,
	input [5:0] stg, //6 bits for stage and 1 bit for enable
	input [DATA_WIDTH-1:0] adda,addb,
	output [DATA_WIDTH:0] result,
	output reg o_en
    );
	//register file declarations
	reg[5:0] i; //6 bits for stage and 1 bit for enable
	wire o;
	//next-state declarations
	reg[DATA_WIDTH-1:0] s0,s1;
	always@(posedge clk,negedge rst_n) begin
	if(!rst_n) begin
		i <= 0;
		o_en <= 0;
	end
	else if(i_en && o_en && i[4] && stg == 15'b0) begin //last stage of the pipeline
		s0 = adda+addb+cout;
		i[3:0] <= stg-1;
	end
	else if(i_en && o_en && i[4] && (stg == 15'b0 || stg == 15'b111_1111)) begin //stage with one input
		s0 = adda+addb+cout;
	end
	else if(i_en && o_en && i[4] && (stg == 15'b0 || stg == 15'b110_0000)) begin //stage with two inputs
		s1 = adda+addb+cout;
	end
	else if(i_en) begin //stage without input
		o_en <= 0;
		i[3:0] <= stg-1;
	end
	else o_en <= 0;
	assign result = s0;
	always@(posedge clk,negedge rst_n) begin
	if(!rst_n) o <= 0; //reset to zero by default
	else if(i[4] && i_en) o <= o+1;
	end
	assign o_en = (o == 2**STG_WIDTH-1);//enable next stage when the output is full-nined
	
endmodule