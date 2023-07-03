
module IF2ID_reg (
    input clk,
    input [31:0] instruction_next,
    input [31:0] inst_address_next,
    input stall,

    output reg [31:0] instruction = 0,
    output reg [31:0] inst_address = 0
);
    
    always @(posedge clk) begin
        if (stall) begin
            instruction <= instruction;
            inst_address <= inst_address;
        end
        else begin
            instruction <= instruction_next;
            inst_address <= inst_address_next;
        end
        
    end

endmodule