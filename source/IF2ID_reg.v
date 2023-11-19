
module IF2ID_reg (
    input clk,
    input rst_n,
    input stall,
    input [31:0] instruction_next,
    input [31:0] inst_address_next,

    output reg [31:0] instruction,
    output reg [31:0] inst_address
);
    
    // Internal registers
    reg [31:0] inst_next;
    reg [31:0] inst_addr_next;

    // Sequential logic
    always @(posedge clk) begin
        if (~rst_n) begin
            instruction <= 32'h00000000;
            inst_address <= 32'h00000000;
        end
        else begin
            instruction <= inst_next;
            inst_address <= inst_addr_next;
        end
    end

    // Combinational logic
    always @(*) begin
        if (stall) begin
            inst_next <= instruction;
            inst_addr_next <= inst_address;
        end
        else begin
            inst_next <= instruction_next;
            inst_addr_next <= inst_address_next;
        end
    end

endmodule