module Program_Counter (clk, reset,PC_write ,PC_in, PC_out);
	input clk, reset,PC_write;
	input [31:0] PC_in;
	output reg [31:0] PC_out;
	always @ (posedge clk or posedge reset)
	begin
		if(reset==1'b1)
			PC_out<=0;
		else if (PC_write==1'b1)
			PC_out<=PC_in;
	end
endmodule