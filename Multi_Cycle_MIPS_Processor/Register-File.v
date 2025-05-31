module Register_File (clk,read_addr_1, read_addr_2, write_addr, read_data_1, read_data_2, write_data, RegWrite);
	input [4:0] read_addr_1, read_addr_2, write_addr;
	input [31:0] write_data;
	input  clk,RegWrite;
	reg checkRegWrite;
	output reg [31:0] read_data_1, read_data_2;
	reg [31:0] Regfile [31:0];
	integer k;
	initial 
	    begin
	        for (k=0; k<32; k=k+1) 
			    begin
				    Regfile[k] = 32'd10;
			    end
			Regfile[8]=32'd1;
			Regfile[9]=32'd2;
			Regfile[10]=32'd3; //$t2
			Regfile[11]=32'd4; //$t3
			
			
			Regfile[17]=32'd99;
			Regfile[18]=32'd60;
			Regfile[19]=32'd30;
	    end
	
	//assign read_data_1 = Regfile[read_addr_1];
        always @(read_data_1 or Regfile[read_addr_1])
	        begin
	          if (read_addr_1 == 0) read_data_1 = 0;
	          else 
	          begin
	          read_data_1 = Regfile[read_addr_1];
	          //$display("read_addr_1=%d,read_data_1=%h",read_addr_1,read_data_1);
	          end
	        end
	//assign read_data_2 = Regfile[read_addr_2];
        always @(read_data_2 or Regfile[read_addr_2])
	        begin
	          if (read_addr_2 == 0) read_data_2 = 0;
	          else 
	          begin
	          read_data_2 = Regfile[read_addr_2];
	          //$display("read_addr_2=%d,read_data_2=%h",read_addr_2,read_data_2);
	          end
	        end
	always @(posedge clk)
	        begin
		      if (RegWrite == 1'b1)
		         begin 
		             Regfile[write_addr] = write_data;
		             $display("Rigister File write_addr=%d write_data=%d",write_addr,write_data);
		         end
	        end
endmodule