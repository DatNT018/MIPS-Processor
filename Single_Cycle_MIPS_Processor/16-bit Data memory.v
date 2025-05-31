// Test Bench
module TestBench_Data_Memory_16bit; 
    reg  MemRead, MemWrite; 
    reg [15:0] addr; // address
    reg [15:0] write_data; 
    wire [15:0] read_data; 
    integer i, error_count;
    Data_Memory_16bit dut(addr, write_data, read_data, MemRead, MemWrite); 
    initial 
        begin 
            $monitor($time," address=%d | write_data=%d | MemWrite=%b MemRead=%b | read_data=%d", addr, write_data, MemWrite, MemRead, read_data); 
                error_count=0; MemRead=1'b1; MemWrite=1'b1;
                // address = 15 with write data = 44
                write_data=44; addr=16'd15;
            #10
            if(!(read_data == write_data))
                begin
                    error_count++;
                    $display("Error 16-bit Data Memory output =%d", error_count);
                end
            // address = 17 with write data = 22
            #10 write_data=22; addr=16'd17;
            #10
            if(!(read_data == write_data))
                begin
                    error_count++;
                    $display("Error 16-bit Data_Memory output =%d", error_count);
                end
            #10 MemWrite=1'b0;
            #10 addr=16'd17;
            #10 if(!(read_data == 16'd22))
                begin
                    error_count++;
                    $display("Error 16-bit Data_Memory output =%d", error_count);
                end
            #10 addr=16'd15;
            #10 
            if(!(read_data == 16'd44))
                begin
                    error_count++;
                    $display("Error 16-bit Data_Memory output =%d", error_count);
                end
            #10
            // Drawing conclusion
            if (error_count==0) 
                begin
	                $display("Summary: Testbench of Data_Memory_16bit completed successfully!");
	            end
	        else
                begin
	                $display("Summary: Something wrong, try again!");
	                $display("Number of errors=%d",error_count);
	            end 
            #10 $finish; 
        end 
endmodule

module Data_Memory_16bit ( addr, write_data, read_data, MemRead, MemWrite);
    input [15:0] addr; // address
    input [15:0] write_data;
    output [15:0] read_data;
    input MemRead, MemWrite,clk;
    reg [15:0] DMemory [255:0];
    integer k;
    assign read_data = (MemRead) ? DMemory[addr] : 15'bx;
    initial begin
        for (k=0; k<64; k=k+1)
            begin
                DMemory[k] = 15'b0;
            end
        end
    
    always @(*)
        begin
            if (MemWrite) DMemory[addr] = write_data;
        end
endmodule
