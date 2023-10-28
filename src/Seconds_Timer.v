//
module Seconds_Timer 
   ( input wire Clock, Reset, Start, Load,
     input wire [7:0] Timer_In_Value,
     output Time_Out,
     output [3:0] Sec1, Sec0	 
   ); 
   

   reg [7:0] Time_Reg;  // for Sec1, Sec0
   wire [3:0] S0_Q, S1_Q;
   
   reg E_Start;
   wire En_Timer, En_S1, R_S1;
   wire E_SS1, R_SS1;
   
   BCD_Counter Seconds0(.Clk(Clock), .Reset(Reset), .Enable(En_Timer), .Q(S0_Q));
   BCD_Counter Seconds1(.Clk(Clock), .Reset(R_S1), .Enable(En_S1), .Q(S1_Q));
   
   
   always @(posedge Clock)
   begin
	     if (Reset) begin
		    Time_Reg <= 8'b00000000;
			E_Start <= 0;	
		 end 
		 else if (Load) 
                 Time_Reg <= Timer_In_Value;
		      else if (Start) 
		         E_Start <= 1;   		 
   end 
   

   assign  En_Timer = ((S1_Q == Time_Reg[7:4]) && (S0_Q == Time_Reg[3:0])) ? 0 : E_Start;
   assign  E_SS1 = (S0_Q == 4'b1001) ? 1 : 0;
   assign  En_S1 = E_SS1 & En_Timer; 
   assign  R_SS1 = ((S1_Q == 4'b1001) && (S0_Q == 4'b1001)) ? 1 : 0;
   assign  R_S1  = R_SS1 | Reset;
   assign  Time_Out =  ((S1_Q == Time_Reg[7:4]) && (S0_Q == Time_Reg[3:0])) ? 1 : 0;
   
   assign  Sec0 = S0_Q;   // 
   assign  Sec1 = S1_Q;   // 
   
endmodule 