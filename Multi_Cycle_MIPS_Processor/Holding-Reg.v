module holding_reg(output_data, input_data, write, clk, reset);
  // data size
  parameter N = 32;
  // inputs
  input [N-1:0] input_data;
  input	write, clk, reset;

  // outputs
  output [N-1:0] output_data;

  // Register content and output assignment
  reg [N-1:0] content;
    // update regisiter contents
  always @(posedge clk or posedge reset) 
  begin
    if (reset) 
    begin
      content <= 0;
    end
    else if (write) 
    begin
      content <= input_data;
    end
  end
  assign output_data = content;
endmodule
