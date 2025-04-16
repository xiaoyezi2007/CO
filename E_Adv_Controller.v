`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:01:19 11/06/2024 
// Design Name: 
// Module Name:    E_Adv_Controller 
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
module E_Adv_Controller(
    input [1:0] M_Tnew,
    input [1:0] W_Tnew,
    input M_RegWrite,
    input W_RegWrite,
    input [4:0] E_A1,
	 input [4:0] E_A2,
    input [4:0] W_A3,
    input [4:0] M_A3,
	 input [2:0] M_GRFWDop,
    output [2:0] rsMUXop,
	 output [2:0] rtMUXop
    );

assign rsMUXop = (M_GRFWDop == 3'b010 && E_A1 == 5'd31 && M_RegWrite == 1'b1) ? 3'b100 :
						(M_Tnew == 2'b00 && (E_A1 == M_A3) && (E_A1 != 5'd0) && M_RegWrite == 1'b1) ? 3'b010 :
						(W_Tnew == 2'b00 && (E_A1 == W_A3) && (E_A1 != 5'd0) && W_RegWrite == 1'b1) ? 3'b001 : 3'b000;
assign rtMUXop = (M_GRFWDop == 3'b010 && E_A2 == 5'd31 && M_RegWrite == 1'b1) ? 3'b100 :
						(M_Tnew == 2'b00 && (E_A2 == M_A3) && (E_A2 != 5'd0) && M_RegWrite == 1'b1) ? 3'b010 :
						(W_Tnew == 2'b00 && (E_A2 == W_A3) && (E_A2 != 5'd0) && W_RegWrite == 1'b1) ? 3'b001 : 3'b000;

endmodule
