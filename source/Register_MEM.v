`timescale 1ns / 1ps

module register_MEM(
	input clk,
	input rst_n,
	input [4:0] read_register_1,
	input [4:0] read_register_2,
	input [4:0] write_register,
	input [31:0] write_data,
	input write_enable,
	
	output reg [31:0] register_1,
	output reg [31:0] register_2
    );
    
	// Internal registers
    reg [31:0] registers [31:0];
	reg [31:0] registers_next [31:0];

	// Loop variables
    integer i, j, k;
    
	// Sequential logic
    always @(negedge clk) begin
		if (~rst_n) begin
			for (i = 0; i < 32; i = i + 1) begin
    			registers[i] <= 32'h00000000;
    		end
		end
		else begin
			for (j = 0; j < 32; j = j + 1) begin
				registers[j] <= registers_next[j];
			end
		end
    end

	// Combinational logic of reg write
	always @(*) begin
		if (write_enable) begin
			registers_next[write_register] = write_data;
		end
		else begin
			for (k = 0; k < 32; k = k + 1) begin
				registers_next[k] = registers[k];
			end
		end
	end

	// Combinational logic of reg read
	always @(*) begin
		register_1 = registers[read_register_1];
    	register_2 = registers[read_register_2];
	end
    
endmodule
