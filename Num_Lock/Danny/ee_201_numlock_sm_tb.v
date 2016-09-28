/*
Danny Pan
Mackenzie Collins
*/

`timescale 100ms / 1ms

module ee201_numlock_sm_tb;

//set variables
reg 	Clk_tb, reset_tb, U_tb, Z_tb
wire 	Unlock_tb;
wire 	q_I_tb, q_G1get_tb, q_G1_tb, q_G10get_tb, q_G10_tb, q_G101get_tb,
 		q_G101_tb, q_G1011get_tb, q_G1011_tb, q_Opening_tb, q_Bad_tb;

//instantiate the numlock_sm module
ee201_numlock_sm UUT (.Clk(Clk_tb), .reset(reset_tb), .U(U_tb), .Z(Z_tb), .Unlock(Unlock_tb),
	.q_I(q_I_tb), .q_G1get(q_G1get_tb), .q_G1(q_G1_tb), .q_G10get(q_G10get_tb), .q_G10(q_G10_tb), 
	.q_G101get(q_G101get_tb), .q_G101(q_G101_tb), .q_G1011get(q_G1011get_tb), .q_G1011(q_G1011_tb),
	.q_Opening(q_Opening_tb), q_Bad(q_Bad_tb));

//intiaize variables
initial begin Clk_tb = 1'b0; end
always  begin #1; Clk_tb = ~ Clk_tb; end
initial begin reset_tb = 1'b1; #3; reset_tb = 1'b0; end
initial 
   begin 
		U = 0; Z = 0;
		#5;
		U = 1; Z = 0;
		#2;
		U = 0; Z = 1;
		#2;
		U = 1; Z = 0;
		#2;
		U = 1; Z = 0;
   end

endmodule