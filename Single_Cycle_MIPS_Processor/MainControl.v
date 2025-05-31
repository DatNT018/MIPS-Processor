module Control(clk, Op_intstruct, ints_function, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Zero, Jump);
    input clk,Zero;
    input [5:0] ints_function;
    input [5:0] Op_intstruct;
    output reg RegDst,Branch,MemRead,MemtoReg,Jump;
    output reg [3:0] ALUOp;
    output reg MemWrite,ALUSrc,RegWrite;
    always @(posedge clk or Op_intstruct or Zero or ints_function)
    begin
        case(Op_intstruct)
            6'b000000:   // R -Type Instruction
                begin
                    RegDst=1;
                    Jump=0;
                    Branch=0;
                    MemRead=0;
                    MemtoReg=0;
                    MemWrite=0;
                    ALUSrc=0;
                    RegWrite=1;
                    if(ints_function==6'b100000)// Addition
                        begin 
                            ALUOp =4'b0000;
                        end
                    if(ints_function==6'b100010)// Subtraction
                        begin 
                            ALUOp =4'b0001;
                        end
                    if(ints_function==6'b011000) // Multiplication
                        begin
                            ALUOp =4'b0010;
                        end         
                    if(ints_function==6'b011010) // Division
                        begin
                            ALUOp =4'b0011;
                        end
                    if(ints_function==6'b100100) // Logical and
                        begin
                            ALUOp =4'b0100;
                        end
                    if(ints_function==6'b100101) // Logical or
                        begin
                            ALUOp =4'b0101;        
                        end
                    if(ints_function==6'b100110) // Logical xor
                        begin
                            ALUOp =4'b0110;        
                        end
                    if(ints_function==6'b100111) // Logical nor
                        begin
                            ALUOp =4'b0111;
                        end
                    if(ints_function==6'b101000) // Logical nand
                        begin
                            ALUOp =4'b1000;        
                        end
                    if(ints_function==6'b101010) // Logical xnor
                        begin
                            ALUOp =4'b1001;
                        end
                    if(ints_function==6'b000000) // Logical shift left
                        begin
                            ALUOp =4'b1010;
                        end
                    if(ints_function==6'b000010) // Logical shift right
                        begin
                            ALUOp =4'b1011;
                        end
                    if(ints_function==6'b111000) // Rotate left
                        begin
                            ALUOp =4'b1100;
                        end
                    if(ints_function==6'b110000) // Rotate right
                        begin
                            ALUOp =4'b1101;
                        end
                end
            6'b000100: // beq instruction
                begin
                    RegDst=0;
                    Jump=0;
                    if (Zero==1) begin
                                    Branch=1;
                                end 
                    else        begin
                                    Branch=0;
                                end
                    MemRead=0;
                    MemtoReg=0;
                    ALUOp =4'b1110;
                    MemWrite=0;
                    ALUSrc=0;
                    RegWrite=0;
                end
            
            6'b100011:  //load word instruction
                begin
                    RegDst=0;
                    Jump=0;
                    Branch=0;
                    MemRead=1;
                    MemtoReg=1;
                    ALUOp =4'b0000;
                    MemWrite=0;
                    ALUSrc=1;
                    RegWrite=1;
                end
            
            6'b101011: // Store Instruction
                begin
                    RegDst=0;
                    Branch=0;
                    Jump=0;
                    MemRead=0;
                    MemtoReg=0;
                    ALUOp =4'b0000;
                    MemWrite=1;
                    ALUSrc=1;
                    RegWrite=0;
                end
             6'b001000: // addi Instruction
                begin
                    RegDst=0;
                    Jump=0;
                    Branch=0;
                    MemRead=0;
                    MemtoReg=0;
                    ALUOp =4'b0000;
                    MemWrite=0;
                    ALUSrc=1;
                    RegWrite=1;
                end
                
            6'b000010: // jump Instruction
                begin
                    RegDst=0;
                    Jump=1;
                    Branch=0;
                    MemRead=0;
                    MemtoReg=0;
                    ALUOp =4'b0000;
                    MemWrite=0;
                    ALUSrc=1;
                    RegWrite=1;
                end
            6'b000101:  //bne
                begin
                    RegDst=0;
                    Jump=0;
                    if (Zero==1) begin
                                    Branch=1;
                                end 
                    else        begin
                                    Branch=0;
                                end
                    MemRead=0;
                    MemtoReg=0;
                    ALUOp =4'b1111;
                    MemWrite=0;
                    ALUSrc=0;
                    RegWrite=0;
                end
                
            default :
                begin
                    RegDst=1;
                    Branch=0;
                    Jump=0;
                    MemRead=0;
                    MemRead=0;
                    MemtoReg=0;
                    ALUOp =4'b0000;
                    MemWrite=0;
                    ALUSrc=0;
                    RegWrite=1;
                end
        endcase
    end
endmodule
