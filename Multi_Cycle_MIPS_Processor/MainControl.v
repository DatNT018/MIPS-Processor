module control(in_reset,opcode, reset,clk,PCWrite,Iord,MemRead,MemWrite,IRwrite,MemtoReg,RegWrite,RegDst,ALUSrcA,ALUSrcB,PCSource,ALUop,PCWrcond);

  // ~~~~~~~~~~~~~~~~~~~ PORTS ~~~~~~~~~~~~~~~~~~~ //

  // opcode, clock, and reset inputs
  input [5:0] opcode;	// from instruction register
  input	clk,in_reset;

  // control signal outputs
  output reg PCWrite,Iord,MemRead,MemWrite,IRwrite,MemtoReg,RegWrite,RegDst,ALUSrcA;
  output reg [1:0] ALUSrcB,PCSource;
  output reg [2:0] ALUop;
  output reg PCWrcond;
  output reg reset;
  // ~~~~~~~~~~~~~~~~~~~ REGISTER ~~~~~~~~~~~~~~~~~~~ //

  // 4-bit state register
  reg [3:0]	state;

  // ~~~~~~~~~~~~~~~~~~~ PARAMETERS ~~~~~~~~~~~~~~~~~~~ //

  // state parameters
  parameter s0  = 4'd0;
  parameter s1  = 4'd1;
  parameter s2  = 4'd2;
  parameter s3  = 4'd3;
  parameter s4  = 4'd4;
  parameter s5  = 4'd5;
  parameter s6  = 4'd6;
  parameter s7  = 4'd7;
  parameter s8  = 4'd8;
  parameter s9  = 4'd9;
  parameter s10  = 4'd10;
  parameter s_Reset  = 4'd11;	// reset
  


  // opcode[5:4] parameters
  parameter J       = 6'b000010;	// Jump or NOP
  parameter R       = 6'b000000;	// R-type
  parameter BEQ     = 6'b000100;	// Branch
  parameter BNE     = 6'b000101;    // Branch
  parameter SW      = 6'b101011;	// I-type
  parameter LW      = 6'b100011;     // I-type
  parameter ADDI    = 6'b001000;    // I-type
  

  // OP code control for ALU

  parameter OP_R_TYPE  = 3'b000;
  parameter OP_I_TYPE  = 3'b001;
  parameter OP_J_TYPE  = 3'b010;
  parameter OP_BR_TYPE = 3'b011;
  parameter OP_IF_TYPE = 3'b100;
  parameter OP_ID_TYPE = 3'b101;
  parameter OP_RS_TYPE = 3'b110;


  // ~~~~~~~~~~~~~~~~~~~ STATE MACHINE ~~~~~~~~~~~~~~~~~~~ //

  // control state machine
  always @(posedge clk or posedge in_reset) 
  begin

    // check for reset signal. If set, write zero to PC and switch to Reset State on next CC.
    if (in_reset) begin
      PCWrite=0;
      Iord=0;
      MemRead=1;
      MemWrite=0;
      IRwrite=1;
      MemtoReg=0;
      RegWrite=0;
      RegDst=0;
      ALUSrcA=0;
      ALUSrcB=2'b01;
      PCSource=2'b00;
      ALUop=OP_RS_TYPE;
      PCWrcond=0;
      reset =1;
      state <= s_Reset;
    end
    else 
    begin	// if reset signal is not set, check state at pos edge
      case (state)
       s_Reset:
            begin
              PCWrite=0;
              Iord=0;
              MemRead=1;
              MemWrite=0;
              IRwrite=1;
              MemtoReg=0;
              RegWrite=0;
              RegDst=0;
              ALUSrcA=0;
              ALUSrcB=2'b01;
              PCSource=2'b00;
              ALUop=OP_RS_TYPE;
              PCWrcond=0;
              reset =0;
              state <= s0;
              $display("state Reset");
            end
      s0:
         begin 
            Iord=0;
            MemRead=1;
            MemWrite=0;
            IRwrite=1;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=0;
            ALUSrcB=2'b01;
            PCSource=2'b00;
            ALUop=OP_IF_TYPE;
            PCWrcond=0;
            state <= s1;
            PCWrite=1;
            $display("state 0");
         end
      s1:
         begin 
            PCWrite=0;
            Iord=0;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=0;
            ALUSrcB=2'b11;
            PCSource=2'b00;
            ALUop=OP_ID_TYPE;
            PCWrcond=0;
            $display("state 1");
            case(opcode[5:0])
                    J:  state <= s9;
                    R:  state <= s6;
                    SW:  state <= s2;
		            LW:  state <= s2;
		            ADDI: state <= s2;
                    BEQ: state <= s8;
            endcase
         end

      s2:
         begin 
            PCWrite=0;
            Iord=1;
            MemRead=1;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=1;
            ALUSrcB=2'b10;
            PCSource=2'b00;
            ALUop=OP_I_TYPE;
            PCWrcond=0;
            $display("state 2");
            if(opcode[5:0]== ADDI)
                begin
                  state <= s10;
                  $display("ADDI state");
                end
            else if(opcode[5:0]== SW)
                     begin
                        state <= s5;
                        $display("SW state");
                     end
                 else 
                     begin
                        state <= s3;
                        $display("SW state");
                     end
            $display("state 2");
         end
      s3:
         begin 
            PCWrite=0;
            Iord=1;
            MemRead=1;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=1;
            ALUSrcB=2'b10;
            PCSource=2'b00;
            ALUop=OP_I_TYPE;
            PCWrcond=0;
            state <= s4;
            $display("state 3");
         end
      s4:
         begin 
            PCWrite=0;
            Iord=1;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=1;
            RegDst=0;
            ALUSrcA=0;
            ALUSrcB=2'b10;
            PCSource=2'b00;
            ALUop=OP_I_TYPE;
            PCWrcond=0;
            state <= s0;
            $display("state 4");
         end
      s5:
         begin 
            PCWrite=0;
            Iord=1;
            MemRead=0;
            MemWrite=1;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=0;
            ALUSrcB=2'b10;
            PCSource=2'b00;
            ALUop=OP_I_TYPE;
            PCWrcond=0;
            state <= s0;
            $display("state 5");
         end

      s6:
         begin 
            PCWrite=0;
            Iord=0;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=1;
            ALUSrcB=2'b00;
            PCSource=2'b00;
            ALUop=OP_R_TYPE;
            PCWrcond=0;
            state <= s7;
            $display("state 6");
         end
 
      s7:
         begin 
            PCWrite=0;
            Iord=0;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=1;
            RegWrite=1;
            RegDst=1;
            ALUSrcA=1;
            ALUSrcB=2'b00;
            PCSource=2'b00;
            ALUop=OP_R_TYPE;
            PCWrcond=0;
            state <= s0;
            $display("state 7");
         end

      s8:
         begin 
            PCWrite=0;
            Iord=0;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=1;
            ALUSrcB=2'b00;
            PCSource=2'b01;
            ALUop=OP_BR_TYPE;
            PCWrcond=1;
            state <= s0;
            $display("state 8");
         end

      s9:
         begin 
            PCWrite=1;
            Iord=0;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=1;
            ALUSrcB=2'b00;
            PCSource=2'b10;
            ALUop=OP_J_TYPE;
            PCWrcond=0;
            state <= s0;
            $display("state 9");
         end
      s10:
         begin 
            PCWrite=0;
            Iord=0;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=1;
            RegWrite=1;
            RegDst=0;
            ALUSrcA=1;
            ALUSrcB=2'b00;
            PCSource=2'b00;
            ALUop=OP_R_TYPE;
            PCWrcond=0;
            state <= s0;
            $display("state 7");
         end
        default: begin
            PCWrite=0;
            Iord=0;
            MemRead=0;
            MemWrite=0;
            IRwrite=0;
            MemtoReg=0;
            RegWrite=0;
            RegDst=0;
            ALUSrcA=0;
            ALUSrcB=2'b01;
            PCSource=2'b00;
            ALUop=OP_RS_TYPE;
            PCWrcond=0;
            $display("state default control");
          state <= s_Reset;
        end
      endcase
    end
  end
endmodule