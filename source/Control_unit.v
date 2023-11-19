`timescale 1ns / 1ps


module Control_unit(
	input [31:0] instruction,
	
	output reg [3:0] op_type
    );
    
    always @(*) begin
        case (instruction[31:26])
            6'b000000: begin
                case (instruction[5:0])
                    6'b100000: op_type = 4'b0001; //add
                    6'b100010: op_type = 4'b0010; //sub
                    6'b100100: op_type = 4'b0011; //and
                    6'b100101: op_type = 4'b0100; //or
                    6'b101010: op_type = 4'b0101; //slt
                    default: op_type = 0;
                endcase
            end
            6'b100011: op_type = 4'b0110; //lw
            6'b101011: op_type = 4'b0111; //sw
            6'b000100: op_type = 4'b1000; //beq
            6'b000010: op_type = 4'b1001; //j
            default: op_type = 0;
        endcase
    end
    
endmodule
