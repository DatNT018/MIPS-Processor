// Test Bench
module TestBench_Register_File_16bit;
    reg clk,RegWrite;
    reg [4:0] read_addr_1, read_addr_2, write_addr;
    reg [15:0] write_data;
    wire [15:0] read_data_1, read_data_2;
    integer error_count;
    Register_File_16bit  dut(clk,read_addr_1, read_addr_2, write_addr, read_data_1, read_data_2, write_data, RegWrite);
    always #5 clk<=~clk;
    initial 
    begin
        $monitor($time,"  clk=%b |read_addr_1=%d read_data_1=%d | read_addr_2=%d, read_data_2=%d | RegWrite=%d | write_addr=%d write_data=%d", clk,read_addr_1, read_data_1, read_addr_2, read_data_2, RegWrite, write_addr, write_data);
            clk=1; error_count=0;
        #10 RegWrite=1; write_addr=5'd4; write_data=16'b0110;
        #10 write_addr=5'd8; write_data=16'b1110;
        #5  RegWrite=0;
        #5  $display("Check address data:");
        
        // Setting conditions
        // Address: 4
        read_addr_1=5'd4;
        #1
        if(!(read_data_1==6))
            begin
                error_count++;
                $display("Error  16-bit Register File =%d",error_count);
            end
        else #10 $display("Data 1 is correct");
        
        // Address: 8
        read_addr_2=5'd8;
        #1
        if(!(read_data_2==14))
            begin
                error_count++;
                $display("Error Register_File_16bit =%d",error_count);
            end 
        else #6 $display("Data 2 is correct");
        
        // Conclusion
        if (error_count==0) 
            begin
	            #1 $display("Summary: Testbench of Data_Memory_16bit completed successfully!");
	        end
	    else
            begin
	            #1 $display("Summary: Something wrong, try again!");
	            $display("Number of errors=%d",error_count);
	        end  
        $finish;
    end
endmodule

module Register_File_16bit (clk, read_addr_1, read_addr_2, write_addr, read_data_1, read_data_2, write_data, RegWrite);
	input [4:0] read_addr_1, read_addr_2, write_addr;
	input [15:0] write_data;
	input clk, RegWrite;
	reg checkRegWrite;
	output reg [15:0] read_data_1, read_data_2;
	reg [15:0] Regfile [31:0];
	integer k;
	initial begin
	for (k=0; k<32; k=k+1) 
			begin
				Regfile[k] = 32'd0;
			end
	end
	//assign read_data_1 = Regfile[read_addr_1];
        always @(read_data_1 or Regfile[read_addr_1])
	        begin
	          if (read_addr_1 == 0) read_data_1 = 0;
	          else 
    	          begin
        	          read_data_1 = Regfile[read_addr_1];
    	          end
	        end
	//assign read_data_2 = Regfile[read_addr_2];
        always @(read_data_2 or Regfile[read_addr_2])
	        begin
	          if (read_addr_2 == 0) read_data_2 = 0;
	          else 
    	          begin
        	          read_data_2 = Regfile[read_addr_2];
    	          end
	        end
	always @(posedge clk)
	        begin
		      if (RegWrite == 1'b1)
		         begin 
		             Regfile[write_addr] = write_data;
		             $display("write_addr=%d write_data=%h",write_addr,write_data);
		         end
	        end
endmodule
