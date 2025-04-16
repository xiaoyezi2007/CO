`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:40 11/05/2024 
// Design Name: 
// Module Name:    EtoM 
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
module EtoM(
    input [31:0] E_ALUout,
    input [31:0] E_GPRrt,
    input [4:0] E_GPRA3,
    input [31:0] E_pc,
	 input [5:0] E_op,
    input [5:0] E_func,
	 input [1:0] E_Tnew,
	 input [4:0] E_rs,
	 input [4:0] E_rt,
	 input [31:0] E_GPRrs,
	 input [4:0] E_ExcCode,
	 input [4:0] E_rd,
	 input E_BD,
    input clk,
    input reset,
	 input Req,
    output [31:0] M_ALUout,
    output [31:0] M_GPRrt,
    output [4:0] M_GPRA3,
    output [31:0] M_pc,
	 output [5:0] M_op,
	 output [5:0] M_func,
	 output [1:0] M_Tnew,
	 output [4:0] M_rs,
	 output [4:0] M_rt,
	 output [4:0] M_ExcCode,
	 output [31:0] M_GPRrs,
	 output [4:0] M_rd,
	 output M_BD
    );

reg [31:0] ALUout;
reg [31:0] GPRrt;
reg [4:0] GPRA3;
reg [31:0] pc;
reg [5:0] op;
reg [5:0] func;
reg [1:0] Tnew;
reg [4:0] rs;
reg [4:0] rt;
reg [31:0] GPRrs;
reg [4:0] ExcCode;
reg [4:0] rd;
reg BD;

always@(posedge clk) begin
	if(reset == 1'b1 || Req == 1'b1) begin
		ALUout <= 0;
		GPRrt <= 0;
		GPRA3 <= 0;
		if(Req == 1'b0) begin
			pc <= 32'h00003000;
		end
		else begin
			pc <= 32'h00004180;
		end
		op <= 0;
		func <= 0;
		Tnew <= 0;
		rs <= 0;
		rt <= 0;
		GPRrs <= 0;
		ExcCode <= 0;
		rd <= 0;
		BD <= 0;
	end
	else begin
		ALUout <= E_ALUout;
		GPRrt <= E_GPRrt;
		GPRA3 <= E_GPRA3;
		pc <= E_pc;
		op <= (E_ExcCode == 0) ? E_op : 0;
		func <= (E_ExcCode == 0) ? E_func : 0;
		Tnew <= (E_Tnew == 2'b00) ? 2'b00 : E_Tnew - 2'b01;
		rs <= (E_ExcCode == 0) ? E_rs : 0;
		rt <= (E_ExcCode == 0) ? E_rt : 0;
		GPRrs <= E_GPRrs;
		ExcCode <= E_ExcCode;
		rd <= (E_ExcCode == 0) ? E_rd : 0;
		BD <= E_BD;
	end
end

assign M_ALUout = ALUout;
assign M_GPRrt = GPRrt;
assign M_GPRA3 = GPRA3;
assign M_pc = pc;
assign M_op = op;
assign M_func = func;
assign M_Tnew = Tnew;
assign M_rs = rs;
assign M_rt = rt;
assign M_GPRrs = GPRrs;
assign M_ExcCode = ExcCode;
assign M_rd = rd;
assign M_BD = BD;
endmodule
