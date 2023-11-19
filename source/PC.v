`timescale 1ns / 1ps

module PC(
	input clk,
	input rst_n,
	input stall,
	input [31:0] old_inst_addr, 
	input [31:0] shift_inst_addr, 
	input [31:0] jump_inst_addr,
	input shift_enable, 
	input jump_enable,
	
	output reg [31:0] inst_addr
    );
    
	// Intertal registers
	reg [31:0] inst_addr_next;

	// Sequential logic
	always @(posedge clk) begin
		if (~rst_n) begin
			inst_addr <= 32'h00000000;
		end
		else begin
			inst_addr <= inst_addr_next;
		end
	end

    // Combinational logic
	always @(*) begin
		if (stall) begin
			inst_addr_next = old_inst_addr;
		end
		else begin
			case ({shift_enable, jump_enable})
				2'b10: inst_addr_next = shift_inst_addr;
				2'b01: inst_addr_next = jump_inst_addr;
				default: inst_addr_next = old_inst_addr + 32'd4;
			endcase
		end
	end

endmodule
