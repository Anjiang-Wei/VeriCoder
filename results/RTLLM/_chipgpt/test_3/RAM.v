module RAM(
    input clk,
    input rst_n,
    input write_en,
    input[7:0]write_addr,
    input[5:0]write_data,
    input read_en,
    input[7:0]read_addr,
    output reg[5:0]read_data
);

//array of registers (RAM)
reg[DEPTH-1:0]ram[2**WIDTH-1:0]; // width is 6 bits and DEPTH is 8 bit
//register array initialized with all bits as "1" except for the first word that needs to be initialized with "0"
always @(posedge clk or negedge rst_n) begin : RAM_initialization
    if(!rst_n) begin
        for(int i=0;i<2**WIDTH;i=i+1) //for each memory location 
            ram[i]={1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; //all bits initialized to "0" except for the first bit that needs to be initialized to "1"
    end
end
//register array used for write operations
always @(posedge clk or negedge rst_n) begin : RAM_write
    if(!rst_n) ram[write_addr]={write_data}; //active-low write enb signal will only be activated at the positive edge of clk
end
//register array used for read operations
always @(posedge clk or negedge rst_n) begin : RAM_read
    if(!rst_n) read_data={1'b0}; //all bits in register will be initialized to "0"
    else if(read_en && {read_addr[6:0]}) read_data=ram[{read_addr[7:0]}] ; //if the active-low read enb signal is active at the positive edge of clk and the bits in the read_addr register are valid then assigns the value of that specific memory location to read_data
end

endmodule