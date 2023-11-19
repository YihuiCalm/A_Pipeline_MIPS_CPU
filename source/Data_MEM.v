`timescale 1ns / 1ps

module data_MEM(
	input clk,
	input rst_n,
	input [31:0] read_addr,
	input [31:0] write_addr,
	input [31:0] write_data,
	input read_enable,
	input write_enable,
	
	output reg [31:0] read_data
    );
    
	// Internal registers
    reg [31:0] data [31:0];
	reg [31:0] data_next [31:0];

	// Loop variables
	integer i, j, k;

	// Sequential logic
    always @(posedge clk) begin
		if (~rst_n) begin
			for (i = 0; i < 32; i = i + 1) begin
				data[i] <= i + 1;
			end
		end
		else begin
			for (j = 0; j < 32; j = j + 1) begin
				data[j] <= data_next[j];
			end
		end
    end

	// Combinational logic of mem write
	always @(*) begin
		if (write_enable) begin
			data_next[write_addr] <= write_data;
		end
		else begin
			for (k = 0; k < 32; k = k + 1) begin
				data_next[k] = data[k];
			end
		end
	end
    
	// Combinational logic of mem read
	always @(*) begin
		if (read_enable) begin
			read_data = data[read_addr];
		end
		else begin
			read_data = 32'h00000000;
		end
	end

endmodule
