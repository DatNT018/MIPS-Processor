// Multi-cycle microprocessor
module  Datapath_Multi_cycle_Processor(clk,in_reset,PC_out,ALU_out);
    input clk, in_reset;
    output [31:0] PC_out,ALU_out;
    wire [31:0] ALU_in_B,ALU_in_A,B_data,mux_2_out,Jump_addr;
    wire [31:0] PC_in,Mem_Read_data,instruction,MDR_out,ALU_out_hold;
    wire PCWr,IRwrite,MemRead;
    wire [27:0] jump_28_bit;
    
    wire [2:0]ALUop;
    wire [31:0] mux_1_out,W_RD1, W_RD2,Extend_out,Branch_addr,A_data;
    wire [4:0] mux_3_out;
    wire PCWrite,zero,PCWrcond,and_out,reset;
    
    wire Iord,MemWrite,MemtoReg,RegWrite,RegDst,ALUSrcA;
    wire [1:0] ALUSrcB,PCSource;
    wire [2:0] Operation_ALU;
    
    Program_Counter     comp1(clk, reset,PCWr,PC_in, PC_out);
    Mux_32_bit          comp2(PC_out, ALU_out_hold, mux_1_out, Iord);
    Data_Memory         comp3(clk,mux_1_out, B_data, Mem_Read_data, MemRead, MemWrite);
    holding_reg         comp4(instruction, Mem_Read_data, IRwrite, clk, reset);
    holding_reg         comp5(MDR_out, Mem_Read_data, 1'b1, clk, reset);
    Mux_32_bit          comp6(MDR_out,ALU_out_hold, mux_2_out, MemtoReg);

    Register_File       comp7(clk,instruction[25:21], instruction[20:16], mux_3_out, W_RD1, W_RD2, mux_2_out, RegWrite);
    Mux_5_bit           comp8(instruction[20:16], instruction[15:11], mux_3_out, RegDst);
    Sign_Extension      comp9(instruction[15:0], Extend_out);
    shift_left_2        comp10(Extend_out, Branch_addr);
    holding_reg         comp11(A_data, W_RD1, 1'b1, clk, reset);
    holding_reg         comp12(B_data, W_RD2, 1'b1, clk, reset);
    Mux_32_bit          comp13(PC_out, A_data, ALU_in_A, ALUSrcA);
    Mux4_32_bit         comp14(B_data, 32'd4,Extend_out,Branch_addr , ALU_in_B, ALUSrcB);
    alu                 comp15(Operation_ALU, ALU_in_A, ALU_in_B, ALU_out,zero);
    holding_reg         comp16(ALU_out_hold, ALU_out , 1'b1, clk, reset);
    
    shift_left_2_28bit  comp17(instruction[25:0], jump_28_bit);
    
    concate             comp18(PC_out[31:28],jump_28_bit,Jump_addr);
    Mux4_32_bit         comp19(ALU_out, ALU_out_hold,Jump_addr, 32'b0, PC_in, PCSource);
    
    control          comp20(in_reset,instruction[31:26], reset,clk,PCWrite,Iord,MemRead,MemWrite,IRwrite,MemtoReg,RegWrite,RegDst,ALUSrcA,ALUSrcB,PCSource,ALUop,PCWrcond);
    ALU_Control         comp21(ALUop,instruction[5:0],Operation_ALU);
    and                 comp22(and_out,zero,PCWrcond);
    or                  comp23(PCWr,and_out,PCWrite);
endmodule


module concate(PC_in,IR_in,PC_out);
    input [3:0] PC_in;
    input [27:0] IR_in;
    output[31:0] PC_out;
    assign PC_out={PC_in, IR_in};
endmodule


module shift_left_2 (sign_in, sign_out);
	input [31:0] sign_in;
	output [31:0] sign_out;
	assign sign_out[31:2]=sign_in[29:0];
	assign sign_out[1:0]=2'b00;
endmodule