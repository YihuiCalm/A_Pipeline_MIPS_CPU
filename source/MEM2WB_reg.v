module MEM2WB_reg (
    input clk,
    input rst_n,
    input flush,
    input [3:0] op_type_next,
    input [31:0] read_data_next,
    input [31:0] alu_result_next,
    input [4:0] write_reg_address_next,

    output reg [3:0] op_type,
    output reg [31:0] read_data,
    output reg [31:0] alu_result,
    output reg [4:0] write_reg_address
);

    always @(posedge clk) begin
        if ((~rst_n)|flush) begin
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