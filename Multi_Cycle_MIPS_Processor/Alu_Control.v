module ALU_Control(Op_intstruct,ints_function,ALUOp);
    input [5:0] ints_function;
    input [2:0] Op_intstruct;
    output reg [2:0] ALUOp;
      // OP code control for ALU

  parameter OP_R_TYPE  = 3'b000;
  parameter OP_I_TYPE  = 3'b001;
  parameter OP_J_TYPE  = 3'b010;
  parameter OP_BR_TYPE = 3'b011;
  parameter OP_IF_TYPE = 3'b100;
  parameter OP_ID_TYPE = 3'b101;
  parameter OP_RS_TYPE = 3'b110;

    always @(*)
    begin
        case(Op_intstruct)
            OP_R_TYPE:   // R -Type Instruction look at fuction
                begin
                    ALUOp =3'b000;
                    if(ints_function==6'b100000) // add
                        begin
                            ALUOp =3'b000;
                            $display("fuction Add");
                        end
                                  
                    if(ints_function==6'b100010) // sub 
                        begin
                            ALUOp =3'b001;
                            $display("fuction sub");
                        end
                                   
                    if(ints_function==6'b100100) // and
                        begin
                            ALUOp =3'b010;
                            $display("fuction and");
                        end
                                   
                    if(ints_function==6'b100101) // or
                        begin
                            ALUOp =3'b010;
                            $display("fuction or ");
                        end
                end
            OP_I_TYPE:  
                begin
                    ALUOp =3'b000;
                    $display("LW or SW");
                end
            OP_J_TYPE: 
                begin
                    ALUOp =3'b000;
                    $display("Jump");
                end
            OP_BR_TYPE: // beq instruction
                begin
                    ALUOp =3'b111;
                    $display("BEQ or BNE");
                end
            OP_IF_TYPE: // Store Instruction
                begin
                    ALUOp =3'b000;
                    $display("Add IF");
                end
            OP_ID_TYPE: // addi Instruction
                begin
                    ALUOp =3'b000;
                    $display("add ID");
                end
            OP_RS_TYPE:  //bne
                begin
                    ALUOp =3'b111;
                    $display("Reset OP");
                end
            default :
                begin
                    ALUOp =3'b000;
		            $display("ALU default");
                end
        endcase
    end
endmodule