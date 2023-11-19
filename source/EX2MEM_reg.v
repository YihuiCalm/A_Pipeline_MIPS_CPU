module EX2MEM_reg (
    input clk,
    input rst_n,
    input flush,
    input [3:0] op_type_next,
    input [31:0] shifted_address_next,
    input [31:0] alu_result_next,
    input [31:0] write_mem_data_next,
    input [4:0] write_reg_address_next,
    input [31:0] jump_address_next,

    output reg [3:0] op_type,
    output reg [31:0] shifted_address,
    output reg [31:0] alu_result,
    output reg [31:0] write_mem_data,                          
    output reg [4:0] write_reg_address,
    output reg [31:0] jump_address
);

    always @(posedge clk) begin
        if (flush|(!rst_n)) begin
            op_type <= 0;
            shifted_address <= 0;
            alu_result <= 0;
            write_mem_data <= 0;
            write_reg_address <= 0;
            jump_address <= 0;
        end
        else begin
            op_type <= op_type_next;
            shifted_address <= shifted_address_next;
            alu_result <= alu_result_next;
            write_mem_data <= write_mem_data_next;
            write_reg_address <= write_reg_address_next;
            jump_address <= jump_address_next;
        end
    end
    
endmodule