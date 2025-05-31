module Mux_16_bit (in0, in1, mux_out, select);
	parameter N = 16;
	input [N-1:0] in0, in1;
	output [N-1:0] mux_out;
	input select;
	assign mux_out = select? in1: in0 ;
endmodule
