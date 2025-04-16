`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:10:40 11/05/2024 
// Design Name: 
// Module Name:    MtoW 
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
module MtoW(
    input [31:0] M_MemRD,
    input [31:0] M_ALUout,
    input [31:0] M_pc,
    input [4:0] M_GPRA3,
	 input [5:0] M_op,
	 input [5:0] M_func,
	 input [1:0] M_Tnew,
	 input [4:0] M_rs,
	 input [31:0] M_CP0out,
	 input [4:0] M_ExcCode,
    input clk,
    input reset,
	 input Req,
    output [31:0] W_MemRD,
    output [31:0] W_ALUout,
    output [31:0] W_pc,
    output [4:0] W_GPRA3,
	 output [5:0] W_op,
	 output [5:0] W_func,
	 output [1:0] W_Tnew,
	 output [4:0] W_rs,
	 output [31:0] W_CP0out
    );

reg [31:0] MemRD;
reg [31:0] ALUout;
reg [31:0] pc;
reg [4:0] GPRA3;
reg [5:0] op;
reg [5:0] func;
reg [1:0] Tnew;
reg [4:0] rs;
reg [31:0] CP0out;
always@(posedge clk) begin
	if(reset == 1'b1 || Req == 1'b1) begin
		MemRD <= 0;
		ALUout <= 0;
		if(Req == 1'b0) begin
			pc <= 32'h00003000;
		end
		else begin
			pc <= 32'h00004180;
		end
		GPRA3 <= 0;
		op <= 0;
		func <= 0;
		Tnew <= 0;
		rs <= 0;
		CP0out <= 0;
	end
	else begin
		MemRD <= M_MemRD;
		ALUout <= M_ALUout;
		pc <= M_pc;
		GPRA3 <= M_GPRA3;
		op <= (M_ExcCode == 0) ? M_op : 0;
		func <= (M_ExcCode == 0) ? M_func : 0;
		Tnew <= (M_Tnew == 2'b00) ? 2'b00 : M_Tnew - 2'b01;
		rs <= (M_ExcCode == 0) ? M_rs : 0;
		CP0out <= M_CP0out;
	end
end

assign W_MemRD = MemRD;
assign W_ALUout = ALUout;
assign W_pc = pc;
assign W_GPRA3 = GPRA3;
assign W_op = op;
assign W_func = func;
assign W_Tnew = Tnew;
assign W_rs = rs;
assign W_CP0out = CP0out;
endmodule
