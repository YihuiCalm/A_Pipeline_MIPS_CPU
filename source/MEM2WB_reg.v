module MEM2WB_reg (
    input clk,
    input reset,
    input [3:0] op_type_next,
    input [31:0] read_data_next,
    input [31:0] alu_result_next,
    input [4:0] write_reg_address_next,

    output reg [3:0] op_type = 0,
    output reg [31:0] read_data = 0,
    output reg [31:0] alu_result = 0,
    output reg [4:0] write_reg_address = 0
);

    always @(posedge clk) begin
        if (reset) begin
            op_type <= 0;
            read_data <= 0;
            alu_result <= 0;
            write_reg_address <= 0;
        end
        else begin
            op_type <= op_type_next;
            read_data <= read_data_next;
            alu_result <= alu_result_next;
            write_reg_address <= write_reg_address_next;
        end
    end
    
endmodule