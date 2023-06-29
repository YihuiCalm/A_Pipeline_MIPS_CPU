
module IF2ID_reg (
    input clk,
    input [31:0] instruction_next,
    input [31:0] inst_address_next,

    output reg [31:0] instruction = 0,
    output reg [31:0] inst_address = 0
);
    
    always @(posedge clk) begin
        instruction <= instruction_next;
        inst_address <= inst_address_next;
    end

endmodule