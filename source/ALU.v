`timescale 1ns / 1ps

module ALU(
	input [3:0] op_type,
	input reg_write_enable_MEM,
	input reg_write_enable_WB,
	input [4:0] reg_write_address_WB,
	input [4:0] reg_write_address_MEM,
	input [31:0] reg_read_data_1_EX,
	input [31:0] reg_read_data_2_EX,
	input [4:0] read_register_1_EX,
	input [4:0] read_register_2_EX,
	input [31:0] extended_immi_EX,
	input [31:0] reg_write_data,
	input [31:0] alu_result_MEM,
	
	output reg [31:0] result
    );
    
	// Opreation parameters
    parameter ADD = 4'b0001;
    parameter SUB = 4'b0010;
    parameter AND = 4'b0011;
    parameter OR = 4'b0100;
    parameter SLT = 4'b0101;
    parameter LW = 4'b0110;
    parameter SW = 4'b0111;
    parameter BEQ = 4'b1000;
    parameter J = 4'b1001;
    
	// Internal registers
	reg [31:0] data_1;
	reg [31:0] data_2;

    always @(*) begin
		case ({reg_write_enable_MEM,reg_write_enable_WB})
			2'b00: begin
				data_1 = reg_read_data_1_EX;
				data_2 = ((op_type==LW)|(op_type==SW))? extended_immi_EX: reg_read_data_2_EX;
			end 
			2'b01: begin
				data_1 = (reg_write_address_WB==read_register_1_EX)? reg_write_data: reg_read_data_1_EX;
				data_2 = ((op_type==LW)|(op_type==SW))? extended_immi_EX: (reg_write_address_WB==read_register_2_EX? reg_write_data: reg_read_data_2_EX);
			end
			2'b10: begin
				data_1 = (reg_write_address_MEM==read_register_1_EX)? alu_result_MEM: reg_read_data_1_EX;
				data_2 = ((op_type==LW)|(op_type==SW))? extended_immi_EX: (reg_write_address_MEM==read_register_2_EX? alu_result_MEM: reg_read_data_2_EX);
			end
			2'b11: begin
				data_1 = (reg_write_address_MEM==read_register_1_EX)? alu_result_MEM: (reg_write_address_WB==read_register_1_EX)? reg_write_data: reg_read_data_1_EX;
				data_2 = ((op_type==LW)|(op_type==SW))? extended_immi_EX: (reg_write_address_MEM==read_register_2_EX? alu_result_MEM: (reg_write_address_WB==read_register_2_EX? reg_write_data: reg_read_data_2_EX));
			end
			default: ;
		endcase 
    	case (op_type)
    		ADD: result = data_1 + data_2;
    		SUB: result = data_1 - data_2;
    		OR: result = data_1 | data_2;
    		AND: result = data_1 & data_2;
    		SLT: result = (data_2 > data_1)? 32'd1: 32'd0;
    		LW,SW: result = data_1 + data_2;
    		BEQ: result = (data_1 == data_2)? 32'd1: 32'd0;
    		default: result = 0;
    	endcase
    end 
    
endmodule
