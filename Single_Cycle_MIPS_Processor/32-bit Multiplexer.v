// Test Bench
module TestBench_Mux_32_bit; 
    reg [31:0] in0, in1; 
    wire [31:0] mux_out; 
    reg select; 
    integer i,error_count;
    Mux_32_bit dut(in0, in1, mux_out, select); 
    initial 
        begin
            $monitor($time," select=%b| input0=%4d| input1=%4d | mux_out=%4d ", select, in0, in1, mux_out); 
                error_count=0; select=0;
                in0=22; in1=66; // initial input values
                #1;
                $display("==> Select input 0");
                for (i=1;i<=4;i=i+1)
                    begin
                        select=~select;
                        // Change input values
                        in0=in0+5;
                        in1=in1+5;
                        #5
                        begin
                            case(select)
                                1'b1: // select = 1
                                    if(!(mux_out==in1))
                                        begin
                                            error_count++;
                                            $display("Error MUX32 select=%b", select, error_count);
                                        end
                                    else
                                        begin
                                            $display("==> Select input 1");
                                        end
                                1'b0: // select = 0
                                    if(!(mux_out==in0))
                                        begin
                                            error_count++;
                                            $display("Error MUX32 select=%b", select, error_count);
                                        end
                                    else
                                        begin
                                            $display("==> Select input 0");
                                        end
                            endcase
                        end
                    end
                #10 // Draw final conclusion
                if (error_count==0) 
                    begin
        	            $display("Summary: Testbench of MUX32 completed successfully!");
        	        end
        	    else
                    begin
            	        $display("Summary: Something wrong, try again!");
            	        $display("Number of errors=%d", error_count);
        	        end
                #5 $finish;
        end
endmodule

module Mux_32_bit (in0, in1, mux_out, select);
	parameter N=32;
	input [N-1:0] in0, in1;
	output [N-1:0] mux_out;
	input select;
	assign mux_out = select ? in1 : in0;
endmodule
