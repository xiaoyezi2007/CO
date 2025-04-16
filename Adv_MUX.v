`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:29:12 11/05/2024 
// Design Name: 
// Module Name:    Adv_MUX 
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
module Adv_MUX(
    input [31:0] GPRrs,
    input [31:0] M_Data,
    input [31:0] W_Data,
    input [31:0] GPRrt,
    input [2:0] rsMUXop,
    input [2:0] rtMUXop,
	 input [31:0] E_pc,
	 input [31:0] M_pc,
    output [31:0] GPRrsOut,
    output [31:0] GPRrtOut
    );
assign GPRrsOut = (rsMUXop == 3'b000) ? GPRrs :
						(rsMUXop == 3'b001) ? W_Data : 
						(rsMUXop == 3'b010) ? M_Data :
						(rsMUXop == 3'b011) ? E_pc + 8 :
						(rsMUXop == 3'b100) ? M_pc + 8 : 32'hffff0000;
assign GPRrtOut = (rtMUXop == 3'b000) ? GPRrt :
						(rtMUXop == 3'b001) ? W_Data : 
						(rtMUXop == 3'b010) ? M_Data :
						(rtMUXop == 3'b011) ? E_pc + 8 :
						(rtMUXop == 3'b100) ? M_pc + 8 : 32'hffff0000;

endmodule
