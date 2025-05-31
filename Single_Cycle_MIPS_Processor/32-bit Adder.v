// Test Bench
module TestBench_Adder32Bit;
	reg [31:0] input1, input2;
	wire [31:0] out;
	Adder32Bit dut(input1, input2, out);
	integer i,error_count;
	initial 
	    begin
            $monitor($time," input1=%4d input2=%4d | output=%4d ",input1, input2, out); 
            error_count=0;
            input1=0;
            input2=3;
            for (i=1; i<=5; i=i+1)
            #5
            begin
                if(!(input1 + input2 == out))
                    begin
                      error_count++;
                      $display("Error Adder ouput=%d",out,error_count);
                    end
                input1 = input1+1;
            end;
            #10
            if (error_count==0) 
                begin
    	            $display("Summary: Testbench of Adder completed successfully!");
    	        end
    	    else
                begin
        	        $display("Summary: Something wrong, try again!");
        	        $display("Numer of errors=%d",error_count);
        	    end
            #5 $finish;
        end
endmodule

module Adder32Bit(input1, input2, out);
    input [31:0] input1, input2;
    output [31:0] out;
    reg [31:0]out;
    always@( input1 or input2)
        begin
            out <= input1 + input2;
        end
endmodule
