`timescale 1ns / 1ps

module CPU_top_tb();

	parameter ADD = 4'b0001;
    parameter SUB = 4'b0010;
    parameter AND = 4'b0011;
    parameter OR  = 4'b0100;
    parameter SLT = 4'b0101;
    parameter LW  = 4'b0110;
    parameter SW  = 4'b0111;
    parameter BEQ = 4'b1000;
    parameter J   = 4'b1001; 
	
	reg clk = 0;
	reg rst_n = 0;

	wire [31:0] inst_address;
	wire [31:0] instruction;

	reg [31:0] inst_mem [31:0];

	reg [16*8-1:0] str_inst;
	reg [3*8-1:0] op_type_ID, op_type_EX, op_type_MEM,op_type_WB;


	CPU_top DUT(
		.clk(clk),
		.rst_n(rst_n),
		.instruction(instruction),
		.inst_address(inst_address)
	);
	
	assign instruction = inst_mem[inst_address>>2];

	integer i;
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			inst_mem[i] = 32'h00000000;
		end
		inst_mem[0] = 32'h8C010000; // lw $1 0($0)
		inst_mem[1] = 32'h8C020001; // lw $2 1($0)
		inst_mem[2] = 32'h00221820; // add $3, $1, $2
		inst_mem[3] = 32'h00602020; // add $4, $3, $0
		inst_mem[4] = 32'h00622824; // and $5, $3, $2
		inst_mem[5] = 32'h00623025; // or $6, $3, $2
		inst_mem[6] = 32'h00812022; // sub $4, $4, $1 
		inst_mem[7] = 32'h10810001; // beq $4, $1, 1
		inst_mem[8] = 32'h08000018; // j 6
		inst_mem[9] = 32'h08000024; // j 9
	end

	initial begin
		forever begin
			#2 clk = ~clk;
		end
	end

	initial begin
		#4
		rst_n = 1;
	end

	always @(*) begin
		case (instruction)
			32'h8C010000: str_inst =  "lw $1 0($0)    ";
			32'h8C020001: str_inst =  "lw $2 1($0)    ";
			32'h00221820: str_inst =  "add $3, $1, $2 ";
			32'h00602020: str_inst =  "add $4, $3, $0 ";
			32'h00622824: str_inst =  "and $5, $3, $2 ";
			32'h00623025: str_inst =  "or $6, $3, $2  ";
			32'h00812022: str_inst =  "sub $4, $4, $1 ";
			32'h10810001: str_inst =  "beq $4, $1, 1  ";
			32'h08000018: str_inst =  "j 6            ";
			32'h08000024: str_inst =  "j 9            ";
		endcase
		op_type_ID =  op_type_str(DUT.op_type_ID);
		op_type_EX =  op_type_str(DUT.op_type_EX);
		op_type_MEM = op_type_str(DUT.op_type_MEM);
		op_type_WB =  op_type_str(DUT.op_type_WB);
	end

	initial begin
		$display("=========================================TESTBENCH===========================================");
		$display("*********************************************************************************************");
		$display("|        IF        |       ID        |       EX        |       MEM        |       WB        |");
		$display("*********************************************************************************************");
	end

	always @(posedge clk) begin
		if (DUT.stall) begin
			$display("|-------STALL------|------STALL------|       %s       |       %s        |       %s       |", op_type_EX, op_type_MEM,op_type_WB);
		end
		else if (DUT.flush) begin
			$display("|-------FLUSH------|------FLUSH------|------FLUSH------|-------FLUSH------|------FLUSH------|");
		end
		else begin
			$display("| %s |       %s       |       %s       |       %s        |       %s       |", str_inst, op_type_ID, op_type_EX, op_type_MEM,op_type_WB);
		end
	end

	initial begin
		$fsdbDumpfile("CPU_top_tb.fsdb");
		$fsdbDumpvars(0);
		$fsdbDumpon;
		
		#200
		$display("==========================================FINISH=============================================");
		
		$fsdbDumpoff;
		$finish;
	end

	function [3*8-1:0] op_type_str;
		input [3:0] op_type_num;
		case (op_type_num)
			4'b0001: op_type_str = "ADD";
			4'b0010: op_type_str = "SUB";
			4'b0011: op_type_str = "AND";
			4'b0100: op_type_str = "OR ";
			4'b0101: op_type_str = "SLT";
			4'b0110: op_type_str = "LW ";
			4'b0111: op_type_str = "SW ";
			4'b1000: op_type_str = "BEQ";
			4'b1001: op_type_str = "J  ";
			default: op_type_str = "---";
		endcase
		
	endfunction
    
endmodule
