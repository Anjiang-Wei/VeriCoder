always @(posedge CLK or posedge RST)
    if(RST) begin
        Secs<=0;
        Mins<=0;
        Hours<=0;
    end
    else begin  //1st always block
        if(Secs=={5'd9,5'd9}) Secs<=0;
        else Secs<={Secs[0],Secs[1]+1};
        if((Mins=={5'd9,5'dix})||(Secs=={5'd9,5'd9})) Mins<=0;
        else Mins<=Mins+1;
    end
always @(posedge CLK or posedge RST)
    if(RST) begin
        Secs<=0;
        Mins<=0;
        Hours<=0;
    end
    else begin  //2nd always block
        if((Mins=={5'd9,5'dix})||(Secs=={5'd9,5'd9})) Mins<=0;
        else Mins<={Mins[0],Mins[1]+1};
        if(Hours==23 || Secs=={5'd9,5'd9} || Mins=={5'd9,5'dix}) Hours<=0;
        else Hours<=Hours+1;
    end
endmodule