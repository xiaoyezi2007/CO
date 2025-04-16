`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:15:08 11/08/2024 
// Design Name: 
// Module Name:    M_Adv_Controller 
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
module M_Adv_Controller(
    input [1:0] W_Tnew,
    input W_RegWrite,
    input [4:0] M_A1,
    input [4:0] M_A2,
    input [4:0] W_A3,
    output [2:0] rsMUXop,
    output [2:0] rtMUXop
    );
assign rsMUXop = (M_A1 == W_A3 && M_A1 != 5'd0 && W_Tnew == 2'b00 && W_RegWrite == 1'b1) ? 3'b001 : 3'b000;
assign rtMUXop = (M_A2 == W_A3 && M_A2 != 5'd0 && W_Tnew == 2'b00 && W_RegWrite == 1'b1) ? 3'b001 : 3'b000;
endmodule
