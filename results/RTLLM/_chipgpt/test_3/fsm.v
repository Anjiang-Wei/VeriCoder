module fsm_gen();
    wire IN,CLK,RST;
    reg MATCH;

    always @(posedge CLK or negedge RST)
        if (~RST) MATCH <= 0;
        else if (IN == 1 && IN[3] == 1) MATCH <= 1;

endmodule