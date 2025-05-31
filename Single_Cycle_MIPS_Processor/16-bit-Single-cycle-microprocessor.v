// Test Bench
module TestBench_SingleCycle_MPS;
    reg reset, clk;
    wire [31:0] W_PC_out, instruction, W_m2;
    wire [15:0] W_RD1, W_RD2, W_MemtoReg, W_m1, W_ALUout;
    wire Jump;
    Single_Cycle_MPS_16bit dut(reset, clk, W_PC_out, instruction,W_RD1, W_RD2, W_m1, W_m2, W_ALUout, W_MemtoReg,Jump);
    always #5 clk=~clk;
    initial begin
        $monitor($time," reset=%b|clk=%b|W_PC_out=%4d|Opcode=%6b|rs=%d|rt=%d|rd=%d|Imm=%h|W_ALUout=%h|W_MemtoReg=%h|W_RD1=%h|W_RD2=%h",reset, clk, W_PC_out, instruction[31:26], instruction[25:21],instruction[20:16],instruction[15:11], instruction[15:0],W_ALUout,W_MemtoReg,W_RD1,W_RD2);
        clk=0; reset=1; $display("                               ----------TEST R-TYPE----------");
        #10 reset=0;
        #135;
        #1 $display("                               ----------TEST I-TYPE----------");
        #90;
        #1 $display("                               ----------TEST J-TYPE----------");
        #15 $finish;
    end
endmodule

// Single Cycle Microprocessor
module Single_Cycle_MPS_16bit(reset, clk, W_PC_out, instruction, W_RD1, W_RD2, W_m1, W_m2, W_ALUout, W_MemtoReg,Jump);
    input reset, clk;
    output [31:0] W_PC_out, instruction, W_m2;
    output [15:0] W_RD1, W_RD2, W_MemtoReg, W_m1, W_ALUout;
    output Jump;
    wire [31:0] W_PC_in, W_PC_out, W_PC_plus_4, W_Branch_add, W_m4, W_Jump_PC;
    wire [15:0] W_RDm;
    wire [4:0] W_m3;
    wire [3:0] ALUop;
    wire PC_Src_sub, PC_Src, RegDst, RegWrite, ALU_Src, zero, MemRead, Branch, MemWrite, MemtoReg;
    
    // Matching components
    Program_Counter         C1(clk, reset, W_PC_in, W_PC_out);
    Adder32Bit              C2(W_PC_out, 32'd4, W_PC_plus_4);
    Mux_32_bit              C3(W_PC_plus_4, W_m2, W_m4, PC_Src);
    Adder32Bit              C4(W_PC_plus_4, W_Branch_add, W_m2);
    Instruction_Memory      C5(W_PC_out, instruction, reset);
    Mux_5_bit               C13(instruction[20:16], instruction[15:11], W_m3, RegDst);
    Register_File_16bit     C6(clk, instruction[25:21], instruction[20:16], W_m3, W_RD1, W_RD2, W_MemtoReg, RegWrite);
    Sign_Extension          C7(instruction[15:0], W_Branch_add);
    Mux_16_bit              C8(W_RD2, instruction[15:0], W_m1, ALU_Src);
    ALU_16bit               C9(ALUop, W_RD1, W_m1, W_ALUout, zero);
    Data_Memory_16bit       C10(clk, W_ALUout, W_RD2, W_RDm, MemRead, MemWrite);
    Mux_16_bit              C11(W_ALUout, W_RDm, W_MemtoReg, MemtoReg);
    
    Control                 C12(clk, instruction[31:26],instruction[5:0], RegDst, Branch, MemRead, MemtoReg, ALUop, MemWrite, ALU_Src, RegWrite, zero, Jump);
    
    Sign_Extension_26       C14(instruction[25:0], W_Jump_PC);
    Mux_32_bit              C15(W_m4, W_Jump_PC, W_PC_in, Jump);
    assign PC_Src = Branch & zero; 
endmodule





// Instruction memory
module Instruction_Memory (read_address, instruction, reset);
	input reset;
	input [31:0] read_address;
	output [31:0] instruction;
	reg [31:0] Imemory [256:0];
	integer k;
	// I-MEM in this case is addressed by word, not by byte
	assign instruction = Imemory[read_address];
	always @(posedge reset)
	begin
	for (k=16; k<32; k=k+1) 
		begin  
		  // here Out changes k=0 to k=16
		  Imemory[k] = 32'b0;
		end
		/*Test R-type*/
        //add $s6, $s5, $s4          R22 = R21 + R20 = 0x3c
        Imemory[0] = 32'b000000_10101_10100_10110_00000_100000;
        //sub $s6, $s5, $s4          R22 = R21 - R20 = 0x32
        Imemory[4] = 32'b000000_10101_10100_10110_00000_100010;
        //mult $s5, $s4              R21 * R20 = 0x113
        Imemory[8] = 32'b000000_10101_10100_00000_00000_011000;
        //div $s5, $s4               R21 / R20 = 0x0b
        Imemory[12] = 32'b000000_10101_10100_00000_00000_011010;
        //and $s6, $s5, $s4          R22 = AND(R21,R20) = 0x05
        Imemory[16] = 32'b000000_10101_10100_10110_00000_100100;
        //or $s6, $s5, $s4           R22 = OR(R21,R20) = 0x37
        Imemory[20] = 32'b000000_10101_10100_10110_00000_100101;
        //xor $s6, $s5, $s4          R22 = XOR(R21,R20) = 0x32
        Imemory[24] = 32'b000000_10101_10100_10110_00000_100110;
        //nor $s6, $s5, $s4          R22 = NOR(R21,R20) = 0xffc8
        Imemory[28] = 32'b000000_10101_10100_10110_00000_100111;
        //nand $s6, $s5, $s4         R22 = NAND(R21,R20) = 0xfffa
        Imemory[32] = 32'b000000_10101_10100_10110_00000_101000;
        //xnor $s6, $s5, $s4         R22 = XNOR(R21,R20) = 0xffcd
        Imemory[36] = 32'b000000_10101_10100_10110_00000_101010;
        //sll $s6, $s5, $s4          R22 = R21<<R20 = 0x6e0
        Imemory[40] = 32'b000000_10101_10100_10110_00000_000000;
        //srl $s6, $s5, $s4          R22 = R21>>R20 = 0x1
        Imemory[44] = 32'b000000_10101_10100_10110_00000_000010;
        //rol $s6, $s5               R22 = R21 rotate 1 bit left = 0x6e
        Imemory[48] = 32'b000000_10101_00000_10110_00000_111000;
        //ror $s6, $s5               R22 = R21 rotate 1 bit right = 0x801b
        Imemory[52] = 32'b000000_10101_00000_10110_00000_110000;
        
        /*Test I-type*/
        //addi $s1, $s1, 0x05        R17 = 0x4e => R17 = R17 + 0x5 = 0x53
        Imemory[56] = 32'b001000_10001_10001_00000_00000_000101;
        //addi $s1, $s1, 0x05        R17 = 0x53 => R17 = R17 + 0x5 = 0x58
        Imemory[60] = 32'b001000_10001_10001_00000_00000_000101;
        //addi $s3, $s1, 0x10        R17 = 0x58 => R19 = R17 + 0x10 = 0x68
        Imemory[64] = 32'b001000_10001_10011_00000_00000_010000;
        //sw  $s3, 0x04($s1)		Memory[$s1+0x04] = $s3
        Imemory[68] = 32'b101011_10001_10011_00000_00000_000100;
        //lw $s7, 0x04($s1)	    	$s7 = Memory[$s1+0x04] 
        Imemory[72] = 32'b100011_10001_10111_00000_00000_000100;
        //beq $s7, $s3, 0x08        R23(0x68) == R19(0x68) move to Imemory[76+8+4]
        Imemory[76] = 32'b000100_10111_10011_00000_00000_001000;
        //addi $s1, $zero, 0x11  
        Imemory[80] = 32'b001000_00000_10001_00000_00000_010001;
        //addi $s1, $zero, 0x22  
        Imemory[84] = 32'b001000_00000_10001_00000_00000_100010;        
        //addi $s1, $zero, 0x33    R17 = 0 + 0x33 = 0x33
        Imemory[88] = 32'b001000_00000_10001_00000_00000_110011;
        //bne $s1, $s7, 0x04       (R17(0x33)!=R23(0x68)) move to Imemory[92+4+4]
        Imemory[92] = 32'b000101_10001_10111_00000_00000_000100;
        //addi $s2, $zero, 0x66  
        Imemory[96] = 32'b001000_00000_10010_00000_00001_100110;
        //addi $s2, $zero, 0x77    R18 = 0+0x77 = 0x77
        Imemory[100] = 32'b001000_00000_10010_00000_00001_110111;
        
        /*Test J-type*/
        //j END // j 0x74         JUMP to Imemory[0x74=116]
        Imemory[104] = 32'b000010_00000_00000_00000_00001_110100;
        //addi $s3, $zero, 0x54  
        Imemory[108] = 32'b001000_00000_10011_00000_00001_010100;
        //addi $s3, $zero, 0x45  
        Imemory[112] = 32'b001000_00000_10011_00000_00001_000101;
        //END: j 0x74            Make a loop Imemory[116]
        Imemory[116] = 32'b000010_00000_00000_00000_00001_110100;
	end
endmodule


