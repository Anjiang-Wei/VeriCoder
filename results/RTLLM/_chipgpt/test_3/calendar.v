always@(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
    end
    else begin
        Secs <= {Secs[1:0], Secs[5] =!{Secs[5:1]}} ; // 1-bit wrap around at the second digit
    end
end

always@(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 0;
    end
    else begin
        if (Secs[5] && Secs!=60) Mins <= {Mins[1:0], Mins[4]=!{Mins[4:1]}} +1'b1; // Wraps around at the 5th digit
	else if (Secs == 60) begin //if both secs and mins are at their max
            Hours <= {Hours[7:0],Hours[3]=!{Hours[3:1]}} +1'b1;
        end
        else Mins <= {Mins[1:0],Mins[4]=!{Mins[4:1]}} ; //Wraps around at the 5th digit
    end
end

endmodule