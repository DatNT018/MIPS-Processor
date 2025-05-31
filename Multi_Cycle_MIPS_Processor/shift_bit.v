module shift_left_2_28bit (sign_in, sign_out);
	input [25:0] sign_in;
	output [27:0] sign_out;
	assign sign_out={2'b00,sign_in};
endmodule