// Test Bench
module TestBench_ALU_16bit;
    //Inputs
    reg[3:0] ALU_Sel;
    reg[15:0] A,B;
    //Outputs
    wire[15:0] ALU_Out;
    wire zero;
    // Verilog code for ALU
    integer i,error_count;
    ALU_16bit dut(ALU_Sel, A, B, ALU_Out, zero);
    initial 
        begin
            // hold reset state for 100 ns.
            $monitor($time," Selection=%b | A=%b B=%b | ALU_Out=%b Branch=%b", ALU_Sel, A, B, ALU_Out, zero);
            error_count=0;
            A = 16'hC; // input 1
            B = 16'hB; // input 2
            ALU_Sel=4'h0; // selection
            // Setting conditions
            for (i=0;i<=14;i=i+1)
                begin
                    #2
                    case(ALU_Sel)
                        4'h0: // Addition
                            if(!(ALU_Out==16'h17))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'h1: // Subtraction 
                            if(!(ALU_Out==16'h01))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end                    
                        4'h2: // Multiplication
                            if(!(ALU_Out==16'h84))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'h3: // Division
                            if(!(ALU_Out==16'h01))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end 
                        4'h4: // Logical and
                            if(!(ALU_Out==16'h08))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'h5: // Logical or
                            if(!(ALU_Out==16'hF))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'h6: // Logical xor
                            if(!(ALU_Out==16'h07))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'h7: // Logical nor
                            if(!(ALU_Out==16'hFFF0))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'h8: // Logical nand
                            if(!(ALU_Out==16'hFFF7))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'h9: // Logical xnor
                            if(!(ALU_Out==16'hFFF8))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'hA: // Logical shift left
                            if(!(ALU_Out==16'h18))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'hB: // Logical shift right
                            if(!(ALU_Out==16'h06))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'hC: // Rotate left
                            if(!(ALU_Out==16'h18))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'hD: // Rotate right
                            if(!(ALU_Out==16'h06))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'hE: // Equal comparison
                            if(!(ALU_Out==16'b0))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                        4'hF: // Not Equal comparison
                            if(!(ALU_Out==16'h01))
                                begin
                                    error_count++;
                                    $display("Error 16-bit ALU select=%b", ALU_Sel, error_count);
                                end
                    endcase
                    #10;
                    ALU_Sel = ALU_Sel + 4'h1;
                end;
            #5 // Drawing conclusion
            if (error_count==0) 
                begin
                    $display("Summary: Testbench of 16-bit ALU completed successfully!");
                end
            else
                begin
                    $display("Summary: Something wrong, try again!");
                    $display("Number of errors=%d", error_count);
                end
            #5 $display("Note: 'Branch' takes the value of variable 'zero'. 'Branch = 1' means system branch to designated instruction. 'Branch = 0' means system does not take a branch.");
            #5 $finish;
        end
endmodule

module ALU_16bit(ALU_Sel, A, B, ALU_Out, zero);
	input [3:0] ALU_Sel; // ALU selection
	input [15:0] A; // 16-bit input 1 
	input [15:0] B; // 16-bit input 2 
	output [15:0] ALU_Out; // ALU 16-bit output
	output reg zero;
    parameter	ALU_OP_ADD	    = 4'b0000, // Addition
			    ALU_OP_SUB	    = 4'b0001, // Subtraction
			    ALU_OP_MUL      = 4'b0010, // Multiplication
			    ALU_OP_DIV      = 4'b0011, // Division
			    ALU_OP_AND	    = 4'b0100, // Logical and 
			    ALU_OP_OR		= 4'b0101, // Logical or
			    ALU_OP_XOR	    = 4'b0110, // Logical xor 
			    ALU_OP_NOR		= 4'b0111, // Logical nor
			    ALU_OP_NAND		= 4'b1000, // Logical nand 
			    ALU_OP_XNOR     = 4'b1001, // Logical xnor
			    ALU_OP_SHL      = 4'b1010, // Logical shift left
			    ALU_OP_SHR      = 4'b1011, // Logical shift right
			    ALU_OP_ROL      = 4'b1100, // Rotate left
			    ALU_OP_ROR      = 4'b1101, // Rotate right
			    ALU_OP_BEQ	    = 4'b1110, // Equal comparison
			    ALU_OP_BNE      = 4'b1111; // Not Equal comparison 

    reg [15:0] ALU_Result;
    assign ALU_Out = ALU_Result; // ALU out
    always @(*)
 begin
		case(ALU_Sel)
			ALU_OP_ADD 	    : ALU_Result = A + B;
			ALU_OP_SUB 	    : ALU_Result = A - B;
			ALU_OP_MUL      : ALU_Result = A * B;
			ALU_OP_DIV      : ALU_Result = A / B;
			ALU_OP_AND 	    : ALU_Result = A & B;
			ALU_OP_OR	    : ALU_Result = A | B;
			ALU_OP_XOR	    : ALU_Result = A ^ B;
			ALU_OP_NOR		: ALU_Result = ~(A | B);
			ALU_OP_NAND		: ALU_Result = ~(A & B);
		    ALU_OP_XNOR     : ALU_Result = ~(A ^ B);
		    ALU_OP_SHL      : ALU_Result = A<<1;
		    ALU_OP_SHR      : ALU_Result = A>>1;
		    ALU_OP_ROL      : ALU_Result = {A[6:0],A[7]};
		    ALU_OP_ROR      : ALU_Result = {A[0],A[7:1]};
			ALU_OP_BEQ	    : begin
					            zero = (A==B)?1'b1:1'b0;
					            ALU_Result = (A==B)?16'd1:16'd0;
					          end
			ALU_OP_BNE      : begin
					            zero = (A!=B)?1'b1:1'b0; 
					            // zero here is different from the above zero
					            // zero here is equal to 1, when A is different from B
					            // zero here is equal to 0, when A is the same as B
					            ALU_Result = (A!=B)?16'd1:16'd0;
					          end
		endcase
    end
endmodule
