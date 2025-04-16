`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:32 10/29/2024 
// Design Name: 
// Module Name:    NPC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NPC(
    input [31:0] PCnow,
    input [2:0] NPCop,
    input [31:0] offset,
    input [25:0] target,
    input [31:0] Regrs,
	 input [31:0] Regrt,
	 input [31:0] EPC,
    output [31:0] PCnxt,
	 output nxtBD,
	 output flush
    );
reg [31:0] out;
reg BD;
always @(*) begin
	case(NPCop)
		0:
		begin
			out = PCnow + 4;
		end
		1:
		begin
			if(Regrs == Regrt) begin
				out = PCnow + 4 + offset;
			end
			else begin
				out = PCnow + 8;
			end
		end
		
		2:
		begin
			out = {PCnow[31:28], target, {2{1'b0}}};
		end
		
		3:
		begin
			out = Regrs;
		end
		4:
		begin
			if(Regrs != Regrt) begin
				out = PCnow + 4 + offset;
			end
			else begin
				out = PCnow + 8;
			end
		end
		5:
		begin
			out = EPC;
		end
	endcase
end
assign PCnxt = out;
assign nxtBD = (NPCop != 0 && NPCop != 5) ? 1 : 0;
assign flush = (NPCop == 5) ? 1 : 0;
endmodule
