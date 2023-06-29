`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 04:29:52 PM
// Design Name: 
// Module Name: CPU_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "../source/CPU_top.v"

module CPU_top_tb(

    );
	
	initial begin
		$fsdbDumpfile("CPU_top_tb.fsdb");
		$fsdbDumpvars(0);
		$fsdbDumpon;
		#910
		$fsdbDumpoff;
		$finish;
	end

    reg clk=0;
    
    always #10 clk = ~clk;
    
	CPU_top u_CPU_top(
		.clk                ( clk                )
	);

    
endmodule
