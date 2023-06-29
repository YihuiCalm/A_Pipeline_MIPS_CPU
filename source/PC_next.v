`timescale 1ns / 1ps


module PC_next(
	input [31:0] inst_addr, shift_inst_addr, jump_inst_addr,
	input shift_enable, jump_enable,
	
	output [31:0] next_inst_addr
    );
    
    assign next_inst_addr = (shift_enable? shift_inst_addr: (jump_enable? jump_inst_addr: inst_addr + 32'd4));
    
endmodule
