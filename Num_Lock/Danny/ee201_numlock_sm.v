timescale 1ns / 1ps

module ee201_numlock_sm(Clk, reset, U, Z, Unlock,
	q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get,
	q_G101, q_G1011get, q_G1011, q_Opening, q_Bad);


	/*  INPUTS */
	// Clock & Reset
	input		Clk, reset;
	input 		U, Z;
	
	/*  OUTPUTS */
	// store current state
	output 		q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get,
				q_G101, q_G1011get, q_G1011, q_Opening, q_Bad;
	//Unlock Output
	output 		Unlock;
	reg [10:0] 	state;	
	reg [1:0] UZ;
	reg [2:0] Timerout_count;
	
	assign {U, Z} = UZ;
	assign {q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get,
				q_G101, q_G1011get, q_G1011, q_Opening, q_Bad} = state;
				
		
	// lets make accessing the state information easier within the state machine code
	// each line aliases the approriate state bits and sets up a 1-hot code
	localparam
	
	Q_I			= 11'b00000000001;
	Q_G1GET		= 11'b00000000010;
	Q_G1		= 11'b00000000100;
	Q_G10GET	= 11'b00000001000;
	Q_G10		= 11'b00000010000;
	Q_G101GET	= 11'b00000100000;
	Q_G101		= 11'b00001000000;
	Q_G1011GET	= 11'b00010000000;
	Q_G1011		= 11'b00100000000;
	Q_OPENING	= 11'b01000000000;
	Q_BAD 		= 11'b10000000000;	
	
	//wire variables
	wire = Timerout;
	

	// NSL AND SM
	always @ (posedge Clk, posedge reset)
	begin
		if(reset)
			state <= Q_I;
		else 
		begin
			case(state)
			Q_I:
				begin
					if (UZ == 2'b10)
						state <= Q_G1GET;
				end	
			Q_G1GET:
				begin
					if ( U == 0)
						state <= Q_G1;
				end
			Q_G1:
				begin
					if (UZ == 2'b01)
						state <= Q_G10GET;
					else if (UZ == 2'b10)
						state <= Q_BAD;
				end
			Q_G10GET:
				begin
					if ( Z == 0)
						state <= Q_G10;
				end
			Q_G10:
				begin
					if ( UZ == 2'b10 )
						state <= Q_G101GET;
					else if (UZ == 2'b01)
						state <= Q_BAD;
				end
			Q_G101GET:
				begin
					if (U == 0)
						state <= Q_G101;
				end
			Q_G101:
				begin
					if ( UZ == 2'b10 )
						state <= Q_G1011GET;
					else if (UZ == 2'b01)
						state <= Q_BAD;
				end
			Q_G1011GET:
				begin
					if (U == 0)
						state <= Q_G1011;
				end
			Q_G1011:
				state <= Q_OPENING;
			Q_OPENING:
				if (Timerout)
					state <= Q_I;
			Q_BAD:
				begin
					if ( UZ = 2'b00)
						state <= Q_I;
				end
			endcase
		end
	end
	
	always @ (posedge Clk, posedge reset)
	begin
		if (Q_OPENING)
			Timerout_count <= Timerout_count + 1;
		else
			Timerout_count <= 0;
	end	
	
	// OFL
	assign Unlock = state && Q_OPENING;
	assign Timerout = Timerout_count && 3'b101;
	
endmodule