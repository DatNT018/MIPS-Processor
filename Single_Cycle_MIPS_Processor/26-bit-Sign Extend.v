module Sign_Extension_26 (sign_in, sign_out);
	input [25:0] sign_in;
	output [31:0] sign_out;
	assign sign_out[25:0]=sign_in[25:0];
	assign sign_out[31:26]=sign_in[25]?6'b111111:6'b0;
endmodule
