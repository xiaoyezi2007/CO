`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:54:16 10/29/2024 
// Design Name: 
// Module Name:    GRF_WD 
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
module GRF_WD(
    input [31:0] ALUout,
    input [31:0] DMout,
    input [31:0] PC,
    input [2:0] GRFWDop,
	 input [31:0] CP0out,
    output [31:0] GRFWDout
    );
reg [31:0] out;
always@(*) begin
	case(GRFWDop)
		0:
		begin
			out = ALUout;
		end
		1:
		begin
			out = DMout;
		end
		2:
		begin
			out = PC + 8;
		end
		3:
		begin
			out = CP0out;
		end
	endcase
end
assign GRFWDout = out;
endmodule
