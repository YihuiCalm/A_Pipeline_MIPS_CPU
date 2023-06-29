# **A-Single-Cycle-MIPS-CPU**
* **Description**: Implementation of A Single-Cycle MIPS CPU  
* **HDL Language**: Verilog  
* **Target Device**: ARTY-A7 35T  
* **Tool Version**: Vivado 2021.2  
***  
## **MIPS32 Instructions**  
This design only realized basic MIPS32 instructions below:  
<table>
    <tr>
        <td align="center">Type</td>
        <td align="center">Instruction</td>
        <td align="center">[31:26]</td>
        <td align="center">[25:21]</td>
        <td align="center">[20:16]</td>
        <td align="center">[15:11]</td>
        <td align="center">[10:6]</td>
        <td align="center">[5:0]</td>
        <td align="center">Function</td>
    </tr>
    <tr>
        <td align="center">R</td>
        <td align="center">add</td>
        <td align="center">000000</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center">rd</td>
        <td align="center">0</td>
        <td align="center">100000</td>
        <td align="center">rd = rs + rt</td>
    </tr>
    <tr>
        <td align="center">R</td>
        <td align="center">sub</td>
        <td align="center">000000</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center">rd</td>
        <td align="center">0</td>
        <td align="center">100010</td>
        <td align="center">rd = rs - rt</td>
    </tr>
    <tr>
        <td align="center">R</td>
        <td align="center">and</td>
        <td align="center">000000</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center">rd</td>
        <td align="center">0</td>
        <td align="center">100100</td>
        <td align="center">rd = rs &amp; rt</td>
    </tr>
    <tr>
        <td align="center">R</td>
        <td align="center">or</td>
        <td align="center">000000</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center">rd</td>
        <td align="center">0</td>
        <td align="center">100101</td>
        <td align="center">rd = rs | rt</td>
    </tr>
    <tr>
        <td align="center">R</td>
        <td align="center">slt</td>
        <td align="center">000000</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center">rd</td>
        <td align="center">0</td>
        <td align="center">101010</td>
        <td align="center">rd = rs &lt; rt? 1: 0</td>
    </tr>
    <tr>
        <td align="center">I</td>
        <td align="center">lw</td>
        <td align="center">100011</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center"  colspan="3">immediate</td>
        <td align="center">rt = mem(rs + imm)</td>
    </tr>
    <tr>
        <td align="center">I</td>
        <td align="center">sw</td>
        <td align="center">101011</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center"  colspan="3">immediate</td>
        <td align="center">mem(rs+imm)=rt</td>
    </tr>
    <tr>
        <td align="center">I</td>
        <td align="center">beq</td>
        <td align="center">000100</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center"  colspan="3">immediate</td>
        <td align="center">PC=rs==rt? PC+4+imm*4: PC+4</td>
    </tr>
    <tr>
        <td align="center">J</td>
        <td align="center">J</td>
        <td align="center">000010</td>
        <td align="center" colspan="5">address</td>
        <td align="center">PC=address</td>
    </tr>
</table>  
For there types of instructions, they have formats of 32-bits below:  
<table>
    <tr>
        <td align="center">Type</td>
        <td align="center">[31:26]</td>
        <td align="center">[25:21]</td>
        <td align="center">[20:16]</td>
        <td align="center">[15:11]</td>
        <td align="center">[10:6]</td>
        <td align="center">[5:0]</td>
    </tr>
    <tr>
        <td align="center">R</td>
        <td align="center">op</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center">rd</td>
        <td align="center">sa</td>
        <td align="center">func</td>
    </tr>
    <tr>
        <td align="center">I</td>
        <td align="center">op</td>
        <td align="center">rs</td>
        <td align="center">rt</td>
        <td align="center"  colspan="3">immediate</td>
    </tr>
    <tr>
        <td align="center">J</td>
        <td align="center">op</td>
        <td align="center"  colspan="5">address</td>
    </tr>
</table>

***  
## **Single-Cycle CPU Architecture**  
The Architecture Design references the [CSE378](https://courses.cs.washington.edu/courses/cse378/) of UW:
![image](https://github.com/YihuiCalm/A-Single-Cycle-MIPS-CPU/assets/96307958/7e28483e-c65b-4df2-938b-59833503e76f)

***
## **Verilog Module Design**
Only the top module is shown here, the specific module could be found in the Vivado project file:
```verilog
module CPU_top(
	input CLK100MHZ,
	output [3:0] op_type,
	output [31:0] reg_write_data, reg_read_data_1, reg_read_data_2,result,inst_addr,mem_read_data,instruction,
	output [4:0] read_register_1, read_register_2, write_register
    );
    
    wire clk;
    
    assign clk = CLK100MHZ;

    wire [31:0] inst_addr, instruction;
    
    Instruction_MEM inst_Instruction(
        .address(inst_addr),
        .instruction(instruction)
    );

    wire [31:0] shift_offset;
    wire [31:0] jump_address;
    wire shift_enable;
    wire jump_enable;
    wire [31:0] next_PC;
    wire [31:0] result;
    
    assign shift_offset = {{16{instruction[15]}},instruction[15:0]};
    assign jump_address = {{6{1'b0}},instruction[25:0]};
    assign shift_enable = (instruction[31:26]==6'b000100)&(result==32'd1);
    assign jump_enable = (instruction[31:26]==6'b000010);
    
    wire [4:0] read_register_1;
    wire [4:0] read_register_2;
    wire [4:0] write_register;
    wire reg_write_enable;
    wire [31:0] reg_write_data, reg_read_data_1, reg_read_data_2;
	
    assign read_register_1 = instruction[25:21];
    assign read_register_2 = instruction[20:16];
    assign write_register = (instruction[31:26]==6'b100011)? instruction[20:16]: instruction[15:11];
    assign reg_write_enable = ((instruction[31:26]==6'b101011)|(instruction[31:26]==6'b000100)|(instruction[31:26]==6'b100000))? 1'b0: 1'b1;
 
    wire [3:0] op_type;
	
    wire [31:0] alu_data_2;
	
    assign alu_data_2 = ((instruction[31:26]==6'b100011)|(instruction[31:26]==6'b101011))? shift_offset: reg_read_data_2;
	
    wire mem_write_enable;
    wire mem_read_enable;
    wire [31:0] mem_read_data;
    
    assign mem_write_enable = (instruction[31:26]==6'b101011);
    assign mem_read_enable = (instruction[31:26]==6'b100011);
    
    assign reg_write_data = (instruction[31:26]==6'b100011)? mem_read_data: result;
    
    PC_next inst_PC_next(
        .address(inst_addr),
        .shift_offset(shift_offset),
        .jump_address(jump_address),
        .shift_enable(shift_enable),
        .jump_enable(jump_enable),
        .next_PC(next_PC)
    );

    PC inst_PC(
        .clk(clk),
        .next_address(next_PC),
        .address(inst_addr)
    );

    register_MEM inst_register(
        .clk(clk),
        .read_register_1(read_register_1),
        .read_register_2(read_register_2),
        .write_register(write_register),
        .write_data(reg_write_data),
        .write_enable(reg_write_enable),
        .register_1(reg_read_data_1),
        .register_2(reg_read_data_2)
    );
     
    Control_unit inst_Countrol_unit(
    	.instruction(instruction),
    	.op_type(op_type)
    );
	
    ALU inst_ALU(
        .data_1(reg_read_data_1),
        .data_2(alu_data_2),
        .op_type(op_type),
        .result(result)
    );

    data_MEM inst_data_MEM(
        .clk(clk),
        .read_addr(result),
        .write_addr(result),
        .write_data(reg_read_data_2),
        .read_enable(mem_read_enable),
        .write_enable(mem_write_enable),
        .read_data(mem_read_data)
    );


endmodule
```
***
## **Simulation**
The testbench MIPS code stored in `Instruction_MEM` module is as followed:
```verilog
mem[0] = 32'h8C010000; // lw $1 0($0)
mem[1] = 32'h8C020001; // lw $2 1($0)
mem[2] = 32'h00221820; // add $3, $1, $2
mem[3] = 32'h00602020; // add $4, $3, $0
mem[4] = 32'h00622824; // and $5, $3, $2
mem[5] = 32'h00623025; // or $6, $3, $2
mem[6] = 32'h00812022; // sub $4, $4, $1 
mem[7] = 32'h10810001; // beq $4, $1, 1
mem[8] = 32'h08000018; // j 6
mem[9] = 32'h08000024; // j 9
```
The program will end in a dead loop. The simulation result is as followed:  
![Screenshot (15)](https://github.com/YihuiCalm/A-Single-Cycle-MIPS-CPU/assets/96307958/f5a546e8-5615-40e8-95c4-a82657b41bce)




