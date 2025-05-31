// Test Bench
module TestBench_Sign_Ext_16to32;
    reg [15:0] sign_in;
    wire [31:0] sign_out;
    integer i,error_count;
    Sign_Ext_16to32 dut(sign_in, sign_out);
    initial 
        begin
            $monitor($time," sign_in = %b | sign_out = %b",sign_in, sign_out);
            sign_in = 16'b1111_0000_1100_0000;
            error_count=0;
            #5
            if(!(sign_out==32'b1111111111111111_1111_0000_1100_0000))
                begin
                    error_count++;
                    $display("Error Sign Extension 16-bit to 32-bit =%d", error_count);
                end
            #5
            sign_in = 16'b0111_0000_1100_1010;
            #5
            if(!(sign_out==32'b0000000000000000_0111_0000_1100_1010))
                begin
                    error_count++;
                    $display("Error Sign Extension 16-bit to 32-bit =%d", error_count);
                end 
            #10
            if (error_count==0) 
                begin
                    $display("Summary: Testbench of Sign Extension 16-bit to 32-bit completed successfully!");
                end
            else
                begin
                    $display("Summary: Something wrong, try again!");
                    $display("Number of errors=%d",error_count);
                end
            #5 $finish;
        end
endmodule

module Sign_Ext_16to32 (sign_in, sign_out);
	input [15:0] sign_in;
	output [31:0] sign_out;
	assign sign_out[15:0]=sign_in[15:0];
	assign sign_out[31:16]=sign_in[15] ? 16'b1111_1111_1111_1111 : 16'b0;
endmodule
