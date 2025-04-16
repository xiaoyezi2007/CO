`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:36:38 11/05/2024 
// Design Name: 
// Module Name:    FtoD 
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
module FtoD(
    input [31:0] Instr,
    input [31:0] F_pc,
	 input [4:0] F_ExcCode,
	 input Stall,
	 input clk,
	 input F_BD,
	 input reset,
	 input flush,
	 input Req,
    output [5:0] op,
    output [31:0] D_pc,
    output [25:0] target,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [5:0] func,
	 output [4:0] D_ExcCode,
    output [15:0] immediate,
	 output D_BD
    );

reg [31:0] instr;
reg [31:0] f_pc;
reg [4:0] ExcCode;
reg BD;
always@(posedge clk) begin
	if(reset == 1'b1 || Req == 1'b1)
	begin
		instr <= 0;
		if(Req == 1'b0) begin
			f_pc <= 32'h00003000;
		end
		else begin
			f_pc <= 32'h00004180;
		end
		ExcCode <= 0;
		BD <= 0;
	end
	else if(Stall == 1'b1)
	begin
		instr <= instr;
		f_pc <= f_pc;
		ExcCode <= ExcCode;
		BD <= BD;
	end
	else if(flush == 1'b1) begin
		instr <= 0;
		f_pc <= F_pc-4;
		ExcCode <= 0;
		BD <= 0;
	end
	else
	begin
		instr <= (F_ExcCode == 0) ? Instr : 0;
		f_pc <= F_pc;
		ExcCode <= F_ExcCode;
		BD <= F_BD;
	end
end

assign op = instr[31:26];
assign rs = instr[25:21];
assign rt = instr[20:16];
assign rd = instr[15:11];
assign func = instr[5:0];
assign immediate = instr[15:0];
assign target = instr[25:0];
assign D_pc = f_pc;
assign D_ExcCode = ExcCode;
assign D_BD = BD;

endmodule
