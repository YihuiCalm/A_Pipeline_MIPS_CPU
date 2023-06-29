`timescale 1ns / 1ps


module register_MEM(
	input clk,
	input [4:0] read_register_1,
	input [4:0] read_register_2,
	input [4:0] write_register,
	input [31:0] write_data,
	input write_enable,
	
	output [31:0] register_1,
	output [31:0] register_2
    );
    
    reg [31:0] registers [4:0];
    integer i;
    initial begin
    	for (i=0;i<5;i=i+1) begin
    		registers[i] = 0;
    	end
    end
    
    always @(posedge clk) begin
    	if (write_enable) registers[write_register] = write_data;
    end
    
    assign register_1 = registers[read_register_1];
    assign register_2 = registers[read_register_2];
    
    
endmodule
