// SW[3:0] input for Data(A), KEY[0] input for clock, SW[9] input for reset_n, SW[7:5] input for Alu
// LEDR[7:0], HEX0[7:0], HEX4[7:0], HEX5[7:0] output display

module enhancedalu(SW, LEDR[7:0], HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY);
	 input [9:0]SW; //initialize input data
	 input [0:0]KEY;
	 output [7:0]LEDR; //output display
	 output [6:0]HEX0;
	 output [6:0]HEX1;
	 output [6:0]HEX2;
	 output [6:0]HEX3;
	 output [6:0]HEX4;
	 output [6:0]HEX5;
	 reg [7:0]Out;
	 wire [7:0]Tuo;
	 wire Out1, Out2, Out3, Out4, Out5, Out6, Out7, Out8, Out9, Out10;
	 wire Outa, Outb, Outc, Outd, Oute, Outf, Outg, Outh, Outi, Outj;
	
	 
	 fulladder f1(
				 .c(1'b0),
				 .a(SW[0]),
				 .b(1'b1),
				 .s(Out2),
				 .e(Out1)
				 );// for case 0
	 fulladder f2(
				 .c(Out1),
				 .a(SW[1]),
				 .b(1'b0),
				 .s(Out3),
				 .e(Out4)
				 );
	 fulladder f3(
				 .c(Out4),
				 .a(SW[2]),
				 .b(1'b0),
				 .s(Out5),
				 .e(Out6)
				 );
	 fulladder f4(
				 .c(Out6),
				 .a(SW[3]),
				 .b(1'b0),
				 .s(Out7),
				 .e(Out8)
				 );
	 fulladder f5(
				 .c(Out8),
				 .a(1'b0),
				 .b(1'b0),
				 .s(Out9),
				 .e(Out10)
				 ); //for case 1
	 dffregister d1(
				 .clock(KEY[0]),
				 .reset_n(SW[9]),
				 .d(Out[7:0]),
				 .q(Tuo[7:0])
				 ); // setting the value for B
	 fulladder f6(
				 .c(1'b0),
				 .a(Tuo[0]),
				 .b(SW[0]),
				 .s(Outb),
				 .e(Outa)
				 ); 
	 fulladder f7(
				 .c(Outa),
				 .a(Tuo[1]),
				 .b(SW[1]),
				 .s(Outc),
				 .e(Outd)
				 );
	 fulladder f8(
				 .c(Outd),
				 .a(Tuo[2]),
				 .b(SW[2]),
				 .s(Oute),
				 .e(Outf)
				 );
	 fulladder f9(
				 .c(Outf),
				 .a(Tuo[3]),
				 .b(SW[3]),
				 .s(Outg),
				 .e(Outh)
				 );
	 fulladder f10(
				 .c(Outh),
				 .a(1'b0),
				 .b(1'b0),
				 .s(Outi),
				 .e(Outj)
				 );

	 always @(*)
	 begin
	     case (SW[7:5]) // start case statement
				3'b000: Out = {3'b000, Out9, Out7, Out5, Out3, Out2}; //case 0
				3'b001: Out = {3'b000, Outi, Outg, Oute, Outc, Outb}; //case 1
				3'b010: Out = {4'b0000, SW[3:0]} + {4'b0000, Tuo[3:0]}; //case 2
				3'b011: Out = {SW[3:0] | Tuo[3:0], SW[3:0] ^ Tuo[3:0]}; //case 3
				3'b100: Out = {7'b0000000, SW[3] | SW[2] | SW[1] | SW[0] | Tuo[0] | Tuo[1] | Tuo[2] | Tuo[3]};// case 4
				3'b101: Out = {4'b0000, Tuo[3:0] << SW[3:0]}; //case 5
				3'b110: Out = {4'b0000, Tuo[3:0] >> SW[3:0]}; // case 6
				3'b111: Out = SW[3:0] * Tuo[3:0]; //case 7
				default: Out = 8'b00000000;
		  endcase
	 end
	 assign LEDR = Out;
	 
	 segment7decoder h0(
			.SW(SW[3:0]),
			.HEX0(HEX0[6:0])
			);
	  
	  segment7decoder1 h1(
	     .SW(SW[3:0]),
		  .HEX1(HEX1[6:0])
		  );
		  
	  segment7decoder2 h2(
	     .SW(SW[3:0]),
		  .HEX2(HEX2[6:0])
		  );
		
	  segment7decoder3 h3(
	     .SW(SW[3:0]),
		  .HEX3(HEX3[6:0])
		  );
		  
	  segment7decoder4 h4(
	     .LEDR(LEDR[3:0]),
		  .HEX4(HEX4[6:0])
		  );
		  
	  segment7decoder5 h5(
	     .LEDR(LEDR[7:4]),
		  .HEX5(HEX5[6:0])
		  );
		  
endmodule

module dffregister(clock, reset_n, d, q);
	 input clock;
	 input reset_n;
	 input [7:0]d;
	 output q;
	 reg [7:0] q;
	 
	 always @(posedge clock)
	 
	 begin
	     if (reset_n == 1'b0)
				q <= 8'b00000000;
		  else
				q <= d;
	 end
endmodule
	 
module fulladder(c, a, b, s, e);
	 input c; //provide one of the initial inputs and be inputs derived from carry bit
	 input a; //input
	 input b; //input
	 output s; //output as sum bit
	 output e; //output as carry bit
	 
	 assign s = b & ~a & ~c | ~b & ~a & c | b & a & c | ~b & a & ~c;
	 assign e = b & c | b & a | a & c;
endmodule

module segment7decoder4(LEDR, HEX4);
	 input [3:0] LEDR; // switches from 0 to 3
	 output [6:0] HEX4; //output
	 
	 hex00 segment0(
			.c3(LEDR[3]),
			.c2(LEDR[2]),
			.c1(LEDR[1]),
			.c0(LEDR[0]),
			.hex0(HEX4[0])
			); //setting up segment 0
	 hex01 segment1(
			.c3(LEDR[3]),
			.c2(LEDR[2]),
			.c1(LEDR[1]),
			.c0(LEDR[0]),
			.hex1(HEX4[1])
			); //setting up segment 1
	 hex02 segment2(
			.c3(LEDR[3]),
			.c2(LEDR[2]),
			.c1(LEDR[1]),
			.c0(LEDR[0]),
			.hex2(HEX4[2])
			); //setting up segment 2
	 hex03 segment3(
			.c3(LEDR[3]),
			.c2(LEDR[2]),
			.c1(LEDR[1]),
			.c0(LEDR[0]),
			.hex3(HEX4[3])
			); //setting up segment 3
	 hex04 segment4(
			.c3(LEDR[3]),
			.c2(LEDR[2]),
			.c1(LEDR[1]),
			.c0(LEDR[0]),
			.hex4(HEX4[4])
			); //setting up segment 4
	 hex05 segment5(
			.c3(LEDR[3]),
			.c2(LEDR[2]),
			.c1(LEDR[1]),
			.c0(LEDR[0]),
			.hex5(HEX4[5])
			); //setting up segment 5
	 hex06 segment6(
			.c3(LEDR[3]),
			.c2(LEDR[2]),
			.c1(LEDR[1]),
			.c0(LEDR[0]),
			.hex6(HEX4[6])
			); //setting up segment 6
endmodule
	 
module segment7decoder5(LEDR, HEX5);
	 input [7:4] LEDR; // switches from 0 to 3
	 output [6:0] HEX5; //output
		 
	 hex00 segment0(
			.c3(LEDR[7]),
			.c2(LEDR[6]),
			.c1(LEDR[5]),
			.c0(LEDR[4]),
			.hex0(HEX5[0])
			); //setting up segment 0
	 hex01 segment1(
			.c3(LEDR[7]),
			.c2(LEDR[6]),
			.c1(LEDR[5]),
			.c0(LEDR[4]),
			.hex1(HEX5[1])
			); //setting up segment 1
	 hex02 segment2(
			.c3(LEDR[7]),
			.c2(LEDR[6]),
			.c1(LEDR[5]),
			.c0(LEDR[4]),
			.hex2(HEX5[2])
			); //setting up segment 2
	 hex03 segment3(
			.c3(LEDR[7]),
			.c2(LEDR[6]),
			.c1(LEDR[5]),
			.c0(LEDR[4]),
			.hex3(HEX5[3])
			); //setting up segment 3
	 hex04 segment4(
			.c3(LEDR[7]),
			.c2(LEDR[6]),
			.c1(LEDR[5]),
			.c0(LEDR[4]),
			.hex4(HEX5[4])
			); //setting up segment 4
	 hex05 segment5(
			.c3(LEDR[7]),
			.c2(LEDR[6]),
			.c1(LEDR[5]),
			.c0(LEDR[4]),
			.hex5(HEX5[5])
			); //setting up segment 5
	 hex06 segment6(
			.c3(LEDR[7]),
			.c2(LEDR[6]),
			.c1(LEDR[5]),
			.c0(LEDR[4]),
			.hex6(HEX5[6])
			); //setting up segment 6
endmodule
	 
module segment7decoder(SW, HEX0);
	 input [3:0] SW; // switches from 0 to 3
	 output [6:0] HEX0; //output
	 
	 hex00 segment0(
			.c3(SW[3]),
			.c2(SW[2]),
			.c1(SW[1]),
			.c0(SW[0]),
			.hex0(HEX0[0])
			); //setting up segment 0
	 hex01 segment1(
			.c3(SW[3]),
			.c2(SW[2]),
			.c1(SW[1]),
			.c0(SW[0]),
			.hex1(HEX0[1])
			); //setting up segment 1
	 hex02 segment2(
			.c3(SW[3]),
			.c2(SW[2]),
			.c1(SW[1]),
			.c0(SW[0]),
			.hex2(HEX0[2])
			); //setting up segment 2
	 hex03 segment3(
			.c3(SW[3]),
			.c2(SW[2]),
			.c1(SW[1]),
			.c0(SW[0]),
			.hex3(HEX0[3])
			); //setting up segment 3
	 hex04 segment4(
			.c3(SW[3]),
			.c2(SW[2]),
			.c1(SW[1]),
			.c0(SW[0]),
			.hex4(HEX0[4])
			); //setting up segment 4
	 hex05 segment5(
			.c3(SW[3]),
			.c2(SW[2]),
			.c1(SW[1]),
			.c0(SW[0]),
			.hex5(HEX0[5])
			); //setting up segment 5
	 hex06 segment6(
			.c3(SW[3]),
			.c2(SW[2]),
			.c1(SW[1]),
			.c0(SW[0]),
			.hex6(HEX0[6])
			); //setting up segment 6
endmodule

module segment7decoder1(SW, HEX1);
	 input [3:0]SW; // switches from 0 to 3
	 output [6:0]HEX1; //output
	 
	 hex00 segment0(
			.c3(1'b1),
			.c2(1'b1),
			.c1(1'b0),
			.c0(1'b1),
			.hex0(HEX1[0])
			); //setting up segment 0
	 hex01 segment1(
			.c3(1'b0),
			.c2(1'b1),
			.c1(1'b0),
			.c0(1'b1),
			.hex1(HEX1[1])
			); //setting up segment 1
	 hex02 segment2(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b1),
			.c0(1'b0),
			.hex2(HEX1[2])
			); //setting up segment 2
	 hex03 segment3(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex3(HEX1[3])
			); //setting up segment 3
	 hex04 segment4(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex4(HEX1[4])
			); //setting up segment 4
	 hex05 segment5(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex5(HEX1[5])
			); //setting up segment 5
	 hex06 segment6(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b0),
			.hex6(HEX1[6])
			); //setting up segment 6
endmodule

module segment7decoder3(SW, HEX3);
	 input [3:0]SW; // switches from 0 to 3
	 output [6:0]HEX3; //output
	 
	 hex00 segment0(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex0(HEX3[0])
			); //setting up segment 0
	 hex01 segment1(
			.c3(1'b0),
			.c2(1'b1),
			.c1(1'b0),
			.c0(1'b1),
			.hex1(HEX3[1])
			); //setting up segment 1
	 hex02 segment2(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b1),
			.c0(1'b0),
			.hex2(HEX3[2])
			); //setting up segment 2
	 hex03 segment3(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex3(HEX3[3])
			); //setting up segment 3
	 hex04 segment4(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex4(HEX3[4])
			); //setting up segment 4
	 hex05 segment5(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex5(HEX3[5])
			); //setting up segment 5
	 hex06 segment6(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b0),
			.hex6(HEX3[6])
			); //setting up segment 6
endmodule

module segment7decoder2(SW, HEX2);
	 input [3:0] SW; // switches from 0 to 3
	 output [6:0] HEX2; //output
	 
	 hex00 segment0(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex0(HEX2[0])
			); //setting up segment 0
	 hex01 segment1(
			.c3(1'b0),
			.c2(1'b1),
			.c1(1'b0),
			.c0(1'b1),
			.hex1(HEX2[1])
			); //setting up segment 1
	 hex02 segment2(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b1),
			.c0(1'b0),
			.hex2(HEX2[2])
			); //setting up segment 2
	 hex03 segment3(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex3(HEX2[3])
			); //setting up segment 3
	 hex04 segment4(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex4(HEX2[4])
			); //setting up segment 4
	 hex05 segment5(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b1),
			.hex5(HEX2[5])
			); //setting up segment 5
	 hex06 segment6(
			.c3(1'b0),
			.c2(1'b0),
			.c1(1'b0),
			.c0(1'b0),
			.hex6(HEX2[6])
			); //setting up segment 6
endmodule

module hex00(c3, c2, c1, c0, hex0);
	 input c3; //correspond to SW[3]
	 input c2; //correspond to SW[2]
	 input c1; //correspond to SW[1]
	 input c0; //correspond to SW[0]
	 output hex0; // segment 0
	 
	 assign hex0 = ~c3 & c2 & ~c1 & ~c0 | ~c3 & ~c2 & ~c1 & c0 | c3 & c2 & ~c1 & c0 | c3 & ~c2 & c1 & c0;
	 
endmodule

module hex01(c3, c2, c1, c0, hex1);
	 input c3; //correspond to SW[3]
	 input c2; //correspond to SW[2]
	 input c1; //correspond to SW[1]
	 input c0; //correspond to SW[0]
	 output hex1; // segment 1
	 
	 assign hex1 = ~c3 & c2 & ~c1 & c0 | c3 & c1 & c0 | c2 & c1 & ~c0 | c3 & c2 & ~c1 & ~c0;
	 
endmodule

module hex02(c3, c2, c1, c0, hex2);
	 input c3; //correspond to SW[3]
	 input c2; //correspond to SW[2]
	 input c1; //correspond to SW[1]
	 input c0; //correspond to SW[0]
	 output hex2; // segment 2
	 
	 assign hex2 = c3 & c2 & ~c1 & ~c0 | c3 & c2 & c1 | ~c3 & ~c2 & c1 & ~c0;
	 
endmodule

module hex03(c3, c2, c1, c0, hex3);
	 input c3; //correspond to SW[3]
	 input c2; //correspond to SW[2]
	 input c1; //correspond to SW[1]
	 input c0; //correspond to SW[0]
	 output hex3; // segment 3
	 
	 assign hex3 = ~c3 & c2 & ~c1 & ~c0 | c2 & c1 & c0 | c3 & ~c2 & c1 & ~c0 | ~c3 & ~c2 & ~c1 & c0;
	 
endmodule

module hex04(c3, c2, c1, c0, hex4);
	 input c3; //correspond to SW[3]
	 input c2; //correspond to SW[2]
	 input c1; //correspond to SW[1]
	 input c0; //correspond to SW[0]
	 output hex4; // segment 4
	 
	 assign hex4 = ~c3 & c2 & ~c1 & ~c0 | ~c3 & c0 | c3 & ~c2 & ~c1 & c0;
	 
endmodule

module hex05(c3, c2, c1, c0, hex5);
	 input c3; //correspond to SW[3]
	 input c2; //correspond to SW[2]
	 input c1; //correspond to SW[1]
	 input c0; //correspond to SW[0]
	 output hex5; // segment 5
	 
	 assign hex5 = ~c3 & ~c2 & ~c1 & c0 | c3 & c2 & ~c1 & c0 | ~c3 & c1 & c0 | ~c3 & ~c2 & c1 & ~c0;
	 
endmodule

module hex06(c3, c2, c1, c0, hex6);
	 input c3; //correspond to SW[3]
	 input c2; //correspond to SW[2]
	 input c1; //correspond to SW[1]
	 input c0; //correspond to SW[0]
	 output hex6; // segment 6
	 
	 assign hex6 = ~c3 & ~c2 & ~c1 | ~c3 & c2 & c1 & c0 | c3 & c2 & ~c1 & ~c0;
	 
endmodule
