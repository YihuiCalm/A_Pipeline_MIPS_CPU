`timescale 1ns / 1ps

`include "Instruction_MEM.v"
`include "ALU.v"
`include "Control_unit.v"
`include "Data_MEM.v"
`include "PC.v"
`include "PC_next.v"
`include "Register_MEM.v"
`include "IF2ID_reg.v"
`include "ID2EX_reg.v"
`include "EX2MEM_reg.v"
`include "MEM2WB_reg.v"

module CPU_top(
    input clk
);

    parameter ADD = 4'b0001;
    parameter SUB = 4'b0010;
    parameter AND = 4'b0011;
    parameter OR = 4'b0100;
    parameter SLT = 4'b0101;
    parameter LW = 4'b0110;
    parameter SW = 4'b0111;
    parameter BEQ = 4'b1000;
    parameter J = 4'b1001; 

    wire [31:0] instruction_IF, instruction_ID; 
    wire [31:0] inst_addr_IF, inst_addr_ID;

    wire [4:0] read_register_1_ID, read_register_1_EX;
    wire [4:0] read_register_2_ID, read_register_2_EX;

    wire reg_write_enable_WB, reg_write_enable_MEM;
    wire [31:0] reg_write_data, reg_read_data_1_ID, reg_read_data_2_ID;

    wire [3:0] op_type_ID, op_type_EX, op_type_MEM, op_type_WB;

    wire [31:0] inst_addr_EX, reg_read_data_1_EX, reg_read_data_2_EX, extended_immi_ID, extended_immi_EX;
    wire [4:0] reg_write_address_1_EX, reg_write_address_2_EX, reg_write_address_EX, reg_write_address_MEM, reg_write_address_WB;
    wire [31:0] jump_inst_addr_EX, jump_inst_addr_MEM;
    
    wire [31:0] alu_result_EX, alu_result_MEM, alu_result_WB;
    reg [31:0] alu_data_1, alu_data_2;

    wire [31:0] shifted_address_EX = inst_addr_EX + 32'd4 + (extended_immi_EX<<2);
    wire [31:0] shifted_address_MEM, write_mem_data_MEM;

    wire mem_write_enable;
    wire mem_read_enable;
    wire [31:0] mem_read_data_MEM, mem_read_data_WB;

    wire shift_enable, jump_enable;

    Instruction_MEM inst_Instruction(
        .address(inst_addr_IF),
        .instruction(instruction_IF)
    );
    
    IF2ID_reg inst_IF2ID_reg(
        .clk(clk),
        .instruction_next(instruction_IF),
        .inst_address_next(inst_addr_IF),
        .instruction(instruction_ID),
        .inst_address(inst_addr_ID)
    );
    
    
    
    assign read_register_1_ID = instruction_ID[25:21];
    assign read_register_2_ID = instruction_ID[20:16];
    
    register_MEM inst_register(
        .clk(clk),
        .read_register_1(read_register_1_ID),
        .read_register_2(read_register_2_ID),
        .write_register(reg_write_address_WB),
        .write_data(reg_write_data),
        .write_enable(reg_write_enable_WB),
        .register_1(reg_read_data_1_ID),
        .register_2(reg_read_data_2_ID)
    );
    
    Control_unit inst_Countrol_unit(
        .instruction(instruction_ID),
        .op_type(op_type_ID)
    );
    
    assign extended_immi_ID = {{16{instruction_ID[15]}},instruction_ID[15:0]};

    ID2EX_reg inst_ID2EX_reg(
        .clk(clk),
        .reset(shift_enable|jump_enable),
        .op_type_next(op_type_ID),
        .address_next(inst_addr_ID),
        .register_1_next(reg_read_data_1_ID),
        .register_2_next(reg_read_data_2_ID),
        .extended_immi_next(extended_immi_ID),
        .reg_write_address_1_next(instruction_ID[20:16]),
        .reg_write_address_2_next(instruction_ID[15:11]),
        .jump_address_next({{6{1'b0}},instruction_ID[25:0]}),
        .register_1_addr_next(read_register_1_ID),
        .register_2_addr_next(read_register_2_ID),
        
        .op_type(op_type_EX),
        .address(inst_addr_EX),
        .register_1(reg_read_data_1_EX),
        .register_2(reg_read_data_2_EX),
        .extended_immi(extended_immi_EX),
        .reg_write_address_1(reg_write_address_1_EX),
        .reg_write_address_2(reg_write_address_2_EX),
        .jump_address(jump_inst_addr_EX),
        .register_1_addr(read_register_1_EX),
        .register_2_addr(read_register_2_EX)
    );
    
    assign reg_write_enable_MEM = ((op_type_WB==ADD)|(op_type_WB==SUB)|(op_type_WB==AND)|(op_type_WB==OR)|(op_type_WB==SLT)|(op_type_WB==LW))? 1'b1: 1'b0;
    assign reg_write_enable_WB = ((op_type_WB==ADD)|(op_type_WB==SUB)|(op_type_WB==AND)|(op_type_WB==OR)|(op_type_WB==SLT)|(op_type_WB==LW))? 1'b1: 1'b0;

    always @(*) begin
       case ({reg_write_enable_MEM,reg_write_enable_WB})
        2'b00: begin
            alu_data_1 <= reg_read_data_1_EX;
            alu_data_2 <= ((op_type_EX==LW)|(op_type_EX==SW))? extended_immi_EX: reg_read_data_2_EX;
        end 
        2'b01: begin
            alu_data_1 <= (reg_write_address_WB==read_register_1_EX)? reg_write_data: reg_read_data_1_EX;
            alu_data_2 <= ((op_type_EX==LW)|(op_type_EX==SW))? extended_immi_EX: (reg_write_address_WB==read_register_2_EX? reg_write_data: reg_read_data_2_EX);
        end
        2'b10: begin
            alu_data_1 <= (reg_write_address_MEM==read_register_1_EX)? ((op_type_MEM==LW)? mem_read_data_MEM: alu_result_MEM): reg_read_data_1_EX;
            alu_data_2 <= ((op_type_EX==LW)|(op_type_EX==SW))? extended_immi_EX: (reg_write_address_MEM==read_register_2_EX? ((op_type_MEM==LW)? mem_read_data_MEM: alu_result_MEM): reg_read_data_2_EX);
        end
        2'b11: begin
            alu_data_1 <= (reg_write_address_MEM==read_register_1_EX)? ((op_type_MEM==LW)? mem_read_data_MEM: alu_result_MEM): (reg_write_address_WB==read_register_1_EX)? reg_write_data: reg_read_data_1_EX;
            alu_data_2 <= ((op_type_EX==LW)|(op_type_EX==SW))? extended_immi_EX: (reg_write_address_MEM==read_register_2_EX? ((op_type_MEM==LW)? mem_read_data_MEM: alu_result_MEM): (reg_write_address_WB==read_register_2_EX? reg_write_data: reg_read_data_2_EX));
        end
        default: ;
       endcase 
    end

    
    ALU inst_ALU(
        .data_1(alu_data_1),
        .data_2(alu_data_2),
        .op_type(op_type_EX),
        .result(alu_result_EX)
    );

    
    assign reg_write_address_EX = (op_type_EX==LW)? reg_write_address_1_EX: reg_write_address_2_EX;
    

    EX2MEM_reg inst_EX2MEM_reg(
        .clk(clk),
        .reset(shift_enable|jump_enable),
        .op_type_next(op_type_EX),
        .shifted_address_next(shifted_address_EX),
        .alu_result_next(alu_result_EX),
        .write_mem_data_next(reg_read_data_2_EX),
        .write_reg_address_next(reg_write_address_EX),
        .jump_address_next(jump_inst_addr_EX),
        
        .op_type(op_type_MEM),
        .shifted_address(shifted_address_MEM),
        .alu_result(alu_result_MEM),
        .write_mem_data(write_mem_data_MEM),
        .write_reg_address(reg_write_address_MEM),
        .jump_address(jump_inst_addr_MEM)
    );
    
    
    
    assign mem_write_enable = (op_type_MEM==SW);
    assign mem_read_enable  = (op_type_MEM==LW);

    MEM2WB_reg u_MEM2WB_reg(
        .clk(clk),
        //.reset(shift_enable|jump_enable),
        .op_type_next(op_type_MEM),
        .read_data_next(mem_read_data_MEM),
        .alu_result_next(alu_result_MEM),
        .write_reg_address_next(reg_write_address_MEM),
        .op_type(op_type_WB),
        .read_data(mem_read_data_WB),
        .alu_result(alu_result_WB),
        .write_reg_address(reg_write_address_WB)
    );

    data_MEM inst_data_MEM(
        .clk(clk),
        .read_addr(alu_result_MEM),
        .write_addr(alu_result_MEM),
        .write_data(write_mem_data_MEM),
        .read_enable(mem_read_enable),
        .write_enable(mem_write_enable),
        .read_data(mem_read_data_MEM)
    );
    
    assign reg_write_data = (op_type_WB==LW)? mem_read_data_WB: alu_result_WB;
    
    assign shift_enable = ((op_type_MEM==BEQ)&(alu_result_MEM==32'd1));
    assign jump_enable = (op_type_MEM==J);
    wire [31:0] next_inst_addr_IF;
    
    PC_next inst_PC_next(
        .inst_addr(inst_addr_IF),
        .shift_inst_addr(shifted_address_MEM),
        .jump_inst_addr(jump_inst_addr_MEM),
        .shift_enable(shift_enable),
        .jump_enable(jump_enable),
        .next_inst_addr(next_inst_addr_IF)
    );

    PC inst_PC(
        .clk(clk),
        .next_inst_addr(next_inst_addr_IF),
        .inst_addr(inst_addr_IF)
    );
endmodule
