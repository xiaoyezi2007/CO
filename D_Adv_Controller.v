`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:17:06 11/06/2024 
// Design Name: 
// Module Name:    D_Adv_Controller 
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
module D_Adv_Controller(
    input [4:0] D_A1,
    input [4:0] D_A2,
    input [1:0] E_Tnew,
    input [1:0] M_Tnew,
    input [1:0] W_Tnew,
    input [1:0] rs_Tuse,
    input [1:0] rt_Tuse,
    input [4:0] M_A3,
    input [4:0] W_A3,
	 input [4:0] E_A3,
	 input E_RegWrite,
	 input M_RegWrite,
	 input W_RegWrite,
	 input E_CP0Write,
	 input M_CP0Write,
	 input [2:0] E_GRFWDop,
	 input [2:0] M_GRFWDop,
	 input Busy,
	 input [2:0] D_MDop,
	 input [1:0] D_HILO_Rop,
	 input [2:0] D_NPCop,
    output Stall,
    output [2:0] rsMUXop,
    output [2:0] rtMUXop,
	 output eret_hazard
    );
wire rs_Tuse0,rt_Tuse0;
assign rs_Tuse0 = (rs_Tuse == 2'b00) ? 1 : 0;
assign rt_Tuse0 = (rt_Tuse == 2'b00) ? 1 : 0;
wire Stall_rs0_E2,Stall_rs0_E1,Stall_rs1_E2,Stall_rs0_M1,Stall_rt0_E2,Stall_rt0_E1,Stall_rt1_E2,Stall_rt0_M1,Stall_MD_Busy,Stall_eret_E,Stall_eret_M;
assign Stall_rs0_E2 = rs_Tuse0 & (E_Tnew == 2'b10) & (D_A1 == E_A3) & (D_A1 != 5'd0) & E_RegWrite;
assign Stall_rs0_E1 = rs_Tuse0 & (E_Tnew == 2'b01) & (D_A1 == E_A3) & (D_A1 != 5'd0) & E_RegWrite;
assign Stall_rs1_E2 = (rs_Tuse ==2'b01) & (E_Tnew == 2'b10) & (D_A1 == E_A3) & (D_A1 != 5'd0) & E_RegWrite;
assign Stall_rs0_M1 = rs_Tuse0 & (M_Tnew == 2'b01) & (D_A1 == M_A3) & (D_A1 != 5'd0) & M_RegWrite;

assign Stall_rt0_E2 = rt_Tuse0 & (E_Tnew == 2'b10) & (D_A2 == E_A3) & (D_A2 != 5'd0) & E_RegWrite;
assign Stall_rt0_E1 = rt_Tuse0 & (E_Tnew == 2'b01) & (D_A2 == E_A3) & (D_A2 != 5'd0) & E_RegWrite;
assign Stall_rt1_E2 = (rt_Tuse ==2'b01) & (E_Tnew == 2'b10) & (D_A2 == E_A3) & (D_A2 != 5'd0) & E_RegWrite;
assign Stall_rt0_M1 = rt_Tuse0 & (M_Tnew == 2'b01) & (D_A2 == M_A3) & (D_A2 != 5'd0) & M_RegWrite;

assign Stall_MD_Busy = Busy & ((D_MDop != 3'b000) || (D_HILO_Rop != 2'b00));
assign Stall_eret_E = (D_NPCop == 3'd5) & E_CP0Write & (E_A3 == 5'd14);

assign Stall = Stall_rs0_E2|Stall_rs0_E1|Stall_rs1_E2|Stall_rs0_M1|Stall_rt0_E2|Stall_rt0_E1|Stall_rt1_E2|Stall_rt0_M1|Stall_MD_Busy|Stall_eret_E;

assign rsMUXop =  (E_GRFWDop == 3'b010 && D_A1 == 5'd31 && E_RegWrite == 1'b1) ? 3'b011 :
						(M_GRFWDop == 3'b010 && D_A1 == 5'd31 && M_RegWrite == 1'b1) ? 3'b100 :
						(M_Tnew == 2'b00 && (D_A1 == M_A3) && (D_A1 != 5'd0) && M_RegWrite == 1'b1) ? 3'b010 :
						(W_Tnew == 2'b00 && (D_A1 == W_A3) && (D_A1 != 5'd0) && W_RegWrite == 1'b1) ? 3'b001 : 3'b000;
assign rtMUXop =  (E_GRFWDop == 3'b010 && D_A2 == 5'd31 && E_RegWrite == 1'b1) ? 3'b011 :
						(M_GRFWDop == 3'b010 && D_A2 == 5'd31 && M_RegWrite == 1'b1) ? 3'b100 :
						(M_Tnew == 2'b00 && (D_A2 == M_A3) && (D_A2 != 5'd0) && M_RegWrite == 1'b1) ? 3'b010 :
						(W_Tnew == 2'b00 && (D_A2 == W_A3) && (D_A2 != 5'd0) && W_RegWrite == 1'b1) ? 3'b001 : 3'b000;
						
assign eret_hazard = (D_NPCop == 3'd5) & M_CP0Write & (M_A3 == 5'd14);

endmodule
