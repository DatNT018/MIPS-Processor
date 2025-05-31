// Test Bench
module TestBench_Instruction_Memory_32bit;
    reg reset;
    reg [31:0] read_address;
    wire [31:0] instruction;
    integer error_count;
    Instruction_Memory_32bit dut(read_address, instruction, reset);
    always #5 read_address=read_address+2; // address increases by 2 
    initial 
        begin
            $monitor($time, " reset=%b | address=%3d | instruction=%b ", reset, read_address, instruction);
            error_count=0; reset=1; read_address=0;
            if(!(instruction==32'b00100000000100100000000001010101)) // address = 0
                begin
                  error_count++;
                  $display("Error  Instruction Memory =%d",error_count);
                end
            #5 reset=0;
            if(!(instruction==32'b00100000000101010000000001110111)) // address = 2
                begin
                  error_count++;
                  $display("Error Instruction Memory =%d",error_count);
                end 
            #5 
            if(!(instruction==32'b00100000000101100000000000010000)) // address = 4
                begin
                  error_count++;
                  $display("Error Instruction Memory =%d",error_count);
                end
            #5 
            if(!(instruction==32'b00100000000101000000000001101000)) // address = 6
                begin
                  error_count++;
                  #1
                  $display("Error Instruction Memory =%d",error_count);
                end
            #1
            if (error_count==0) 
                begin
        	        $display("Summary: Testbench of Instruction Memory completed successfully!");
        	    end
        	else
                begin
        	        $display("Summary: Something wrong, try again!");
        	        $display("Number of errors=%d",error_count);
        	    end
            $finish;      
        end
endmodule

module Instruction_Memory_32bit (read_address, instruction, reset);
	input reset;
	input [31:0] read_address;
	output [31:0] instruction;
	reg [31:0] Imemory [255:0];
	integer k;
	// I-MEM in this case is addressed by word, not by byte
	assign instruction = Imemory[read_address];
	always @(posedge reset)
	begin
	for (k=16; k<32; k=k+1) 
		begin  
		  Imemory[k] = 32'b0;
		end
        //addi $s2, $zero, 0x55 //  load immediate value 0x54 to register $s2
        Imemory[0] = 32'b00100000000100100000000001010101;
        //addi $s3, $zero, 0x22 //  load immediate value 0x22 to register $s3
        Imemory[1] = 32'b00100000000100110000000000100010;
        //addi $s5, $zero, 0x77 //  load immediate value 0x77 to register $s5
        Imemory[2] = 32'b00100000000101010000000001110111;
        //addi $s7, $zero, 0x88	//	load immediate value 0x88 to register $s7 
        Imemory[3] = 32'b00100000000101110000000010001000;
        //addi $s6, $zero, 0x10	//	load immediate value 0x10 to register $s6 
        Imemory[4] = 32'b00100000000101100000000000010000;
        //addi $s1, $zero, 0x44	//	load immediate value 0x44 to register $s1
        Imemory[5] = 32'b00100000000100010000000001000100;
        //addi $s4, $zero, 0x68	//	load immediate value 0x68 to register $s1
        Imemory[6] = 32'b00100000000101000000000001101000;
	end
endmodule



		// /*Test R-type*/
    //     //add $s6, $s5, $s4          R22 = R21 + R20 = 0x3c
    //     Imemory[0] = 32'b000000_10101_10100_10110_00000_100000;
    //     //sub $s6, $s5, $s4          R22 = R21 - R20 = 0x32
    //     Imemory[4] = 32'b000000_10101_10100_10110_00000_100010;
    //     //mult $s5, $s4              R21 * R20 = 0x113
    //     Imemory[8] = 32'b000000_10101_10100_00000_00000_011000;
    //     //div $s5, $s4               R21 / R20 = 0x0b
    //     Imemory[12] = 32'b000000_10101_10100_00000_00000_011010;
    //     //and $s6, $s5, $s4          R22 = AND(R21,R20) = 0x05
    //     Imemory[16] = 32'b000000_10101_10100_10110_00000_100100;
    //     //or $s6, $s5, $s4           R22 = OR(R21,R20) = 0x37
    //     Imemory[20] = 32'b000000_10101_10100_10110_00000_100101;
    //     //xor $s6, $s5, $s4          R22 = XOR(R21,R20) = 0x32
    //     Imemory[24] = 32'b000000_10101_10100_10110_00000_100110;
    //     //nor $s6, $s5, $s4          R22 = NOR(R21,R20) = 0xffc8
    //     Imemory[28] = 32'b000000_10101_10100_10110_00000_100111;
    //     //nand $s6, $s5, $s4         R22 = NAND(R21,R20) = 0xfffa
    //     Imemory[32] = 32'b000000_10101_10100_10110_00000_101000;
    //     //xnor $s6, $s5, $s4         R22 = XNOR(R21,R20) = 0xffcd
    //     Imemory[36] = 32'b000000_10101_10100_10110_00000_101010;
    //     //sll $s6, $s5, $s4          R22 = R21<<R20 = 0x6e0
    //     Imemory[40] = 32'b000000_10101_10100_10110_00000_000000;
    //     //srl $s6, $s5, $s4          R22 = R21>>R20 = 0x1
    //     Imemory[44] = 32'b000000_10101_10100_10110_00000_000010;
    //     //rol $s6, $s5               R22 = R21 rotate 1 bit left = 0x6e
    //     Imemory[48] = 32'b000000_10101_00000_10110_00000_111000;
    //     //ror $s6, $s5               R22 = R21 rotate 1 bit right = 0x801b
    //     Imemory[52] = 32'b000000_10101_00000_10110_00000_110000;
        
    //     /*Test I-type*/
    //     //addi $s1, $s1, 0x05        R17 = 0x4e => R17 = R17 + 0x5 = 0x53
    //     Imemory[56] = 32'b001000_10001_10001_00000_00000_000101;
    //     //addi $s1, $s1, 0x05        R17 = 0x53 => R17 = R17 + 0x5 = 0x58
    //     Imemory[60] = 32'b001000_10001_10001_00000_00000_000101;
    //     //addi $s3, $s1, 0x10        R17 = 0x58 => R19 = R17 + 0x10 = 0x68
    //     Imemory[64] = 32'b001000_10001_10011_00000_00000_010000;
    //     //sw  $s3, 0x04($s1)		Memory[$s1+0x04] = $s3
    //     Imemory[68] = 32'b101011_10001_10011_00000_00000_000100;
    //     //lw $s7, 0x04($s1)	    	$s7 = Memory[$s1+0x04] 
    //     Imemory[72] = 32'b100011_10001_10111_00000_00000_000100;
    //     //beq $s7, $s3, 0x08        R23(0x68) == R19(0x68) move to Imemory[76+8+4]
    //     Imemory[76] = 32'b000100_10111_10011_00000_00000_001000;
    //     //addi $s1, $zero, 0x11  
    //     Imemory[80] = 32'b001000_00000_10001_00000_00000_010001;
    //     //addi $s1, $zero, 0x22  
    //     Imemory[84] = 32'b001000_00000_10001_00000_00000_100010;        
    //     //addi $s1, $zero, 0x33    R17 = 0 + 0x33 = 0x33
    //     Imemory[88] = 32'b001000_00000_10001_00000_00000_110011;
    //     //bne $s1, $s7, 0x04       (R17(0x33)!=R23(0x68)) move to Imemory[92+4+4]
    //     Imemory[92] = 32'b000101_10001_10111_00000_00000_000100;
    //     //addi $s2, $zero, 0x66  
    //     Imemory[96] = 32'b001000_00000_10010_00000_00001_100110;
    //     //addi $s2, $zero, 0x77    R18 = 0+0x77 = 0x77
    //     Imemory[100] = 32'b001000_00000_10010_00000_00001_110111;
        
    //     /*Test J-type*/
    //     //j END // j 0x74         JUMP to Imemory[0x74=116]
    //     Imemory[104] = 32'b000010_00000_00000_00000_00001_110100;
    //     //addi $s3, $zero, 0x54  
    //     Imemory[108] = 32'b001000_00000_10011_00000_00001_010100;
    //     //addi $s3, $zero, 0x45  
    //     Imemory[112] = 32'b001000_00000_10011_00000_00001_000101;
    //     //END: j 0x74            Make a loop Imemory[116]
    //     Imemory[116] = 32'b000010_00000_00000_00000_00001_110100;