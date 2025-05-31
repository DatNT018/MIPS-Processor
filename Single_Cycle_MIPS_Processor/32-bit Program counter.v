// Test Bench
module TestBench_Program_Counter;
    reg clk, reset;
	reg [31:0] PC_in;
	wire [31:0] PC_out;
	integer i, error_count;
	Program_Counter dut(clk, reset, PC_in, PC_out);
	initial 
	    begin
            $monitor($time," clk=%b reset=%b PC_in=%b | PC_out=%3b ",clk,reset,PC_in,PC_out); 
            error_count=0;
            clk=0; reset=1; PC_in=4'b0111;
            for (i=1; i<=2; i=i+1)
            #5 // Condition setting
            begin
                case(reset)
                   1'b1: 
                    if(!(PC_out==1'b0))
                        begin
                          error_count++;
                          $display("Error PC reset=%b: error=%2d", reset, error_count);
                        end
                   1'b0: 
                    if(!(PC_out==PC_in))
                        begin
                          error_count++;
                          $display("Error PC reset=%b: error=%2d", reset, error_count);
                        end 
                endcase
                clk =~ clk;
                reset=~reset;
            end;
            #5 
            if (error_count==0) 
                begin
        	        $display("Summary: Testbench of PC completed successfully!");
        	    end
    	    else
                begin
        	        $display("Summary: Something wrong, try again!");
        	        $display("Number of errors=%d",error_count);
        	    end
            #5 $finish;
        end
endmodule

module Program_Counter (clk, reset, PC_in, PC_out);
	input clk, reset;
	input [31:0] PC_in;
	output reg [31:0] PC_out;
	always @ (posedge clk or posedge reset)
    	begin
    		if(reset==1'b1)
    			PC_out<=0;
    		else
    			PC_out<=PC_in;
    	end
endmodule
