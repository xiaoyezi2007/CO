`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:38 11/05/2024 
// Design Name: 
// Module Name:    DtoE 
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
module DtoE(
    input [31:0] D_GPRrs,
    input [31:0] D_GPRrt,
    input [31:0] D_offset,
    input [5:0] D_op,
    input [5:0] D_func,
    input [4:0] D_rs,
    input [4:0] D_rt,
    input [4:0] D_rd,
    input [31:0] D_pc,
	 input [4:0] D_ExcCode,
	 input D_BD,
	 input Stall,
	 input clk,
	 input reset,
	 input Req,
    output [31:0] E_pc,
    output [31:0] E_GPRrs,
    output [31:0] E_GPRrt,
    output [5:0] E_op,
    output [5:0] E_func,
    output [4:0] E_rs,
    output [4:0] E_rt,
    output [4:0] E_rd,
	 output [4:0] E_ExcCode,
    output [31:0] E_offset,
	 output E_BD
    );

reg [31:0] GPRrs;
reg [31:0] GPRrt;
reg [31:0] offset;
reg [5:0] op;
reg [5:0] func;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [31:0] pc;
reg [4:0] ExcCode;
reg BD;

always@(posedge clk) begin
	if(reset == 1'b1 || Req == 1'b1) begin
		GPRrs <= 0;
		GPRrt <= 0;
		offset <= 0;
		op <= 0;
		func <= 0;
		rs <= 0;
		rt <= 0;
		rd <= 0;
		if(reset == 1'b1) begin
			pc <= 32'h00003000;
			BD <= 0;
		end
		else if(Req == 1'b1) begin
			pc <= 32'h00004180;
			BD <= 0;
		end
		ExcCode <= 0;
	end
	else if(Stall == 1'b1) begin
		GPRrs <= 0;
		GPRrt <= 0;
		offset <= 0;
		op <= 0;
		func <= 0;
		rs <= 0;
		rt <= 0;
		rd <= 0;
		pc <= D_pc;
		BD <= D_BD;
		ExcCode <= D_ExcCode;
	end
	else begin
		GPRrs <= D_GPRrs;
		GPRrt <= D_GPRrt;
		offset <= (D_ExcCode == 0) ? D_offset : 0;
		op <= (D_ExcCode == 0) ? D_op : 0;
		func <= (D_ExcCode == 0) ? D_func : 0;
		rs <= (D_ExcCode == 0) ? D_rs : 0;
		rt <= (D_ExcCode == 0) ? D_rt : 0;
		rd <= (D_ExcCode == 0) ? D_rd : 0;
		pc <= D_pc;
		ExcCode <= D_ExcCode;
		BD <= D_BD;
	end
end

assign E_GPRrs = GPRrs;
assign E_GPRrt = GPRrt;
assign E_offset = offset;
assign E_op = op;
assign E_func = func;
assign E_rs = rs;
assign E_rt = rt;
assign E_rd = rd;
assign E_pc = pc;
assign E_ExcCode = ExcCode;
assign E_BD = BD;

endmodule
