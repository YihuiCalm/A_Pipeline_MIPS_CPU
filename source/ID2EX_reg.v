module ID2EX_reg (
    input clk,
    input reset,
    input [3:0] op_type_next,
    input [31:0] address_next,
    input [31:0] register_1_next,
    input [31:0] register_2_next,
    input [31:0] extended_immi_next,
    input [4:0] reg_write_address_1_next,
    input [4:0] reg_write_address_2_next,
    input [31:0] jump_address_next,
    input [4:0] register_1_addr_next, register_2_addr_next,
    input stall,

    output reg [3:0] op_type = 0,
    output reg [31:0] address = 0,
    output reg [31:0] register_1 = 0,
    output reg [31:0] register_2 = 0,
    output reg [31:0] extended_immi = 0,
    output reg [4:0] reg_write_address_1 = 0,
    output reg [4:0] reg_write_address_2 = 0,
    output reg [31:0] jump_address = 0,
    output reg [4:0] register_1_addr = 0, 
    output reg [4:0] register_2_addr = 0
);
    
    always @(posedge clk) begin
        if (reset|stall) begin
            op_type <= 0;
            address <= 0;
            register_1 <= 0;
            register_2 <= 0;
            extended_immi <= 0;
            reg_write_address_1 <= 0;
            reg_write_address_2 <= 0;
            jump_address <= 0;
            register_1_addr <= 0;
            register_2_addr <= 0;
        end
        else begin
            op_type <= op_type_next;
            address <= address_next;
            register_1 <= register_1_next;
            register_2 <= register_2_next;
            extended_immi <= extended_immi_next;
            reg_write_address_1 <= reg_write_address_1_next;
            reg_write_address_2 <= reg_write_address_2_next;
            jump_address <= jump_address_next;
            register_1_addr <= register_1_addr_next;
            register_2_addr <= register_2_addr_next;
        end
    end

endmodule