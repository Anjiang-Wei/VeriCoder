module adder_8bit(
	input wire[7:0] a,b,cin,
	output wire[7:0]y,co
    );
	 
	 //use small bit-width adder here
	 wire sum;
	 assign sum=a^b ^ cin;
	 assign y[0]=a[0]+b[0]+cin;
	 assign y[1]=a[1]+b[1]+(sum>>1); 
	 assign y[2]=a[2]+b[2]+(sum>>2);
	 assign y[3]=a[3]+b[3]+(sum>>3); 
	 assign y[4]=a[4]+b[4]+(sum>>4);
	 assign y[5]=a[5]+b[5]+(sum>>5);
	 assign y[6]=a[6]+b[6]+(sum>>6);
	 assign y[7]=a[7]+b[7]+(sum>>7); 
	 assign co=y[1] ^ (y[2] + y[3] + y[4]); //output carry for 8-bit adder

endmodule