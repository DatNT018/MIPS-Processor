//Top-level module for multi-cycle microprocessor
module FPGA_TB (
    input [17:0] SW,          
    input [3:0] KEY,         
    output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output [17:0] LEDR,      
    output [7:0] LEDG        
);
    wire [31:0] PC_out, ALU_out;
    wire reset;              

 
    Datapath_Multi_cycle_Processor dut (.clk(KEY[0]),.in_reset(SW[0]),.PC_out(PC_out),.ALU_out(ALU_out)    
    );

    hex_ssd H0 (.BIN(ALU_out[3:0]),   .SSD(HEX0));
    hex_ssd H1 (.BIN(ALU_out[7:4]),   .SSD(HEX1));
    hex_ssd H2 (.BIN(ALU_out[11:8]),  .SSD(HEX2));
    hex_ssd H3 (.BIN(ALU_out[15:12]), .SSD(HEX3));
    hex_ssd H4 (.BIN(ALU_out[19:16]), .SSD(HEX4));
    hex_ssd H5 (.BIN(ALU_out[23:20]), .SSD(HEX5));
    hex_ssd H6 (.BIN(PC_out[3:0]), .SSD(HEX6));
    hex_ssd H7 (.BIN(PC_out[7:4]), .SSD(HEX7));


    assign LEDG[0] = ALU_out[0];          
    assign LEDR[15:0] = PC_out[15:0];    
    assign LEDR[17:16] = 2'b00;           
    assign LEDG[7:1] = 7'b0000000;    

endmodule

// Seven-segment display decoder
module hex_ssd (
    input [3:0] BIN,
    output reg [0:6] SSD
);
    always @(*) begin
        case (BIN)
            4'h0: SSD = 7'b0000001;
            4'h1: SSD = 7'b1001111;
            4'h2: SSD = 7'b0010010;
            4'h3: SSD = 7'b0000110;
            4'h4: SSD = 7'b1001100;
            4'h5: SSD = 7'b0100100;
            4'h6: SSD = 7'b0100000;
            4'h7: SSD = 7'b0001111;
            4'h8: SSD = 7'b0000000;
            4'h9: SSD = 7'b0001100;
            4'hA: SSD = 7'b0001000;
            4'hB: SSD = 7'b1100000;
            4'hC: SSD = 7'b0110001;
            4'hD: SSD = 7'b1000010;
            4'hE: SSD = 7'b0110000;
            4'hF: SSD = 7'b0111000;
            default: SSD = 7'b1111111;
        endcase
    end
endmodule

















