// 
		 
module BCD_Counter 
   (  input wire Clk, Reset, Enable,
      output reg [3:0] Q);
	  
	always @(posedge Clk)
	begin
	   if (Reset) 
	      Q <= 4'b0000;
	   else if (Enable) 
	      if (Q == 4'b1001) 
		     Q <= 4'b0000;
		  else 
		     Q <= Q + 1;
	end 
endmodule 