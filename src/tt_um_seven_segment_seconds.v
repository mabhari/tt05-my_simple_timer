`default_nettype none

module tt_um_mabhari_seven_segment_seconds #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


/* ---------------------------------------------------------------- 
This is a two-digits timer, which can count from 00 to 99 in seconds. The time to stop counting is 
given through 8 input switches (ui_in) as two BCD numbers (which can be from 00 to 99). This number 
is loaded into an internal register when input Load is '1'. Then when input Start is '1' the counting
begins. The timer stops when it reaches the specified count number and then output Time_Out will become '1'.  
------------------------------------------------------------------- */


    
    // ------- From the example code (or based on that) --------
    wire [6:0] led_out;
    assign uo_out[6:0] = led_out;
    assign uo_out[7] = 1'b0;
	// ---------------------------------------------------------

    // set bidirectionals as inputs or outputs properly as described below 
    assign uio_oe = 8'b11110000;
	assign uio_out[6:0] = 7'b0000000;   // Unused outputs

    wire S_Reset = ! rst_n;
	wire Timer_Clk; 
	wire [3:0] Sec_Ones, Sec_Tens;
        reg [3:0] Number;
	
	Clock_Divider c_divider (.Clk_In(clk), .Reset(S_Reset), .Clk_Out(Timer_Clk));
	
	// input ui_in provides the timer value as two BCD numbers for the seconds (from 00 to 99)
	// input uio_in[0] is used for Start and uio_in[1] is used for Load
	// output uio_out[7] is used for Time_Out
	
	// For the following two lines I assumed the design is enabled to work if ena is '1'
	wire S_Start = uio_in[0] & ena; 
	wire S_Load = uio_in[1] & ena; 
	
	//
	Seconds_Timer s_timer (.Clock(Timer_Clk), .Reset(S_Reset), .Start(S_Start), .Load(S_Load),
                           .Timer_In_Value(ui_in),
                           .Time_Out(uio_out[7]),
                           .Sec1(Sec_Tens), .Sec0(Sec_Ones)); 	 
   
    
	
	// input uio_in[3] selects which number (Sec_Tens or Sec_Ones) is displayed on 7-Seg. 
	// When it is 0, Sec_Ones is diplayed otherwise, Sec_Ones is displayed on 7-Seg.  
	always @(uio_in[3], Sec_Ones, Sec_Tens)
	begin 
	   if (uio_in[3]) 
	      Number = Sec_Tens;
	   else 
	      Number = Sec_Ones;
	end 
	
	
	// BCD number to be displaed on 7-Segment display
	// seg is used from the example code 
    seg7 seg7(.counter(Number), .segments(led_out));

endmodule
