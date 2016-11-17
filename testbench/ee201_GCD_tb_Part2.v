
`timescale 1 ns / 100 ps

module ee201_GCD_tb_Part2;

	// Inputs
	reg Clk_tb, CEN_tb;
	reg Reset_tb;
	reg Start_tb;
	reg Ack_tb;
	reg [7:0] Ain_tb;
	reg [7:0] Bin_tb;

	// Outputs
	wire [7:0] A_tb, B_tb, AB_GCD_tb, i_count_tb;
	wire q_I_tb;
	wire q_Sub_tb;
	wire q_Mult_tb;
	wire q_Done_tb;
	reg [6*8:0] state_string_tb; // 6-character string for symbolic display of state
	
	integer clk_cnt, start_Clk_cnt, clocks_taken;
	integer hr;
	integer min;
	
	ee201_GCD UUT (
	.Clk(Clk_tb),
	.CEN(CEN_tb),
	.Reset(Reset_tb),
	.Start(Start_tb),
	.Ack(Ack_tb),
	.Ain(Ain_tb),
	.Bin(Bin_tb),
	.A(A_tb),
	.B(B_tb),
	.AB_GCD(AB_GCD_tb),
	.i_count(i_count_tb),
	.q_I(q_I_tb),
	.q_Sub(q_Sub_tb),
	.q_Mult(q_Mult_tb),
	.q_Done(q_Done_tb)
	);
	
	task APPLY_STIMULUS;
      input [7:0] Ain_value;
      input [7:0] Bin_value;
    begin
		#1;
		Ain_tb = Ain_value;
		Bin_tb = Bin_value;
		Start_tb = 1;

		@(posedge Clk_tb);
		#1;
		start_Clk_cnt = clk_cnt;
		Start_tb = 0;

		wait(q_Done_tb);
		$display ("Ain: %d Bin: %d GCD: %d", Ain_tb, Bin_tb, AB_GCD_tb);
		#1;		
		clocks_taken = clk_cnt - start_Clk_cnt;
		Ack_tb = 1;	
		$display ("It took %d clock(s) to compute the GCD", clocks_taken);		
		@(posedge Clk_tb);
		Ack_tb = 0;		
	end
	endtask
	
	//Clock generator code
	initial
		begin: CLOCK_GENERATOR
		Clk_tb = 0;
		forever
			begin
				#5
				Clk_tb = ~ Clk_tb;
			end
		end
		
	always @(posedge Clk_tb)
	begin
		clk_cnt = clk_cnt + 1;
	end
	
	initial
		begin
		Reset_tb = 1;
		CEN_tb = 1;
		Start_tb = 0;
		Ack_tb = 0;
		clk_cnt = 0;

		wait(q_I_tb);
		Reset_tb = 0;
		
		for (hr = 1; hr <= 23; hr = hr+1)
			for (min = 1; min <= 59; min = min+1)
				APPLY_STIMULUS(hr,min);
			
		
	end
	
	
	
	
	
endmodule