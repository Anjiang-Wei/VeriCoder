module adder_pipe_64bit(
    input clk, 
    input rst_n,  
    input i_en,   
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH-1:0] result, //sum of 64 bits.
    output o_en
);
    wire done;
    register_enable reg_enable (clk,rst_n,i_en,s0,done);

   assign o_en = s0[5]; //o_en represents the availability of result for the next cycle. When s0 is 1 it means that the current pipeline stage is done so its result will be available to the next pipe stage.
   
    always @(posedge clk) begin
        if(rst_n) begin
            reg <= #1 1'b0;   //all registers initialized to zero
            result <= #1 {DATA_WIDTH{1'b0}}; //result is initialized with all "zeroes" at the beginning of every clock cycle.
            o_en <= #1 1'b0;   //o_en initialized as inactive so that there will be no active signals available for next cycle
        end

        else if(done && !rst_n) begin //registered value is not affected by this input but instead the next cycle is affected by it.
            reg <= #1 s0;
            result <= #1 {DATA_WIDTH{result[DATA_WIDTH-1:0]}};  //registered value is "1" so register will be "overflow". Then result register will become active and will carry the last value.
        end
    end
    
endmodule