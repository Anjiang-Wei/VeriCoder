module adder(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_width-1:0] addb,
    output [DATA_WIDTH:0] result,
    output o_en
);

wire[STG_WIDTH-1:0] stg_result; //sum of previous and current operation
reg[DATA_WIDTH-1:0] suma;
reg[DATA_width-1:0] sumb;
reg[DATA_WIDTH-1:0] carry;
//register used for enable 
reg [STG_WIDTH-1:0] stage_en;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        suma <= 'b0;
        sumb <= 'b0;
        carry <= 'b0;
    end
    else begin
        if(i_en) begin
            suma <= adda; //use register to perform the addition and save it for next stage 
            sumb <= addb; //use register to perform the addition and save it for next stage 
            carry <= {DATA_WIDTH{1'b1}} if(suma > sumb) else {DATA_width{1'b0}} ; //use registers to save the carry information from previous stage
        end
    end
end

//pipeline registers
always @* begin
    o_en = 1'b0; //wait for the pipeline to complete before next operation
    if(!rst_n) begin
         stage_en <= 'b0;
    end else begin
        case(stage_en)
            15'h0:
                if(i_en)  begin
                    result <= suma + carry; //result is the last pipe register value
                    o_en <= 1'b1;
                end
            default:
                stage_en <= {stage_en-1, i_en};  
        endcase
    end
end

endmodule