module Mux4_32_bit (in0, in1,in2, in3, mux_out, select);
	parameter N = 32;
	input [N-1:0] in0, in1,in2,in3;
	output [N-1:0] mux_out;
	input [1:0]select;
	assign mux_out = select[1]? (select[0]?in3: in2):(select[0]?in1:in0);
endmodule