// Clock Converter
// This component divides the input clock frequency by spefice ratio. 
// (HALF_RATIO indicates half of the divided ratio).
// For example, the default value of parameter HALF_RATIO divides clock frequency from 10 MHz to 1 Hz.

module Clock_Divider #( parameter HALF_RATIO = 24'd5_000_000 )
   (  input wire Clk_In, Reset,
      output reg Clk_Out);
	  
    reg [23:0] Counter; 
	
	always @(posedge Clk_In)
	begin
	   if (Reset) 
	   begin
		  Counter <= 0;
		  Clk_Out <= 0;
           end 
	   else if (Counter == (HALF_RATIO - 1)) 
	        begin  		  
             Clk_Out <= ~Clk_Out;		
             Counter <= 0;
            end
       else 
            Counter <= Counter + 1;	   
       end 
endmodule 