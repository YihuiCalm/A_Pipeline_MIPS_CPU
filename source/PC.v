`timescale 1ns / 1ps

module PC(
	input clk,
	input [31:0] next_inst_addr,

	output reg [31:0] inst_addr = 0
    );
    
    always @(posedge clk) begin 
    	inst_addr <= next_inst_addr;
    end
    
endmodule
