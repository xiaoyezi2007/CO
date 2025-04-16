`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:11:45 11/20/2024 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
	 input Timer0out,
	 input Timer1out,
	 input IGout,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);

wire [31:0]PCnxt;
wire [31:0]Instr;
wire [31:0]PCnow;
wire Stall;
wire Req;
wire [2:0] D_NPCop;
reg [31:0] IFU_pc;
wire [4:0] F_ExcCode;
wire Exc_AdEL;
wire F_BD;

always @(posedge clk) begin
	if(reset == 1'b1) begin
		IFU_pc <= 32'h3000;
	end
	else if(Req == 1'b1) begin
		IFU_pc <= 32'h4180;
	end
	else if(Stall == 1'b1) begin
		IFU_pc <= IFU_pc;
	end
	else begin
		IFU_pc <= (D_NPCop == 3'b000) ? PCnow + 4 : PCnxt;
	end
end
assign i_inst_addr = IFU_pc;
assign PCnow = IFU_pc;
assign Instr = i_inst_rdata;
assign ExcAdEL = (PCnow[1:0] != 2'b00 || PCnow < 32'h00003000 || PCnow > 32'h00006ffc) ? 1 : 0;
assign F_ExcCode = (ExcAdEL == 1'b1) ? 4 : 0;
/*********F*********/
wire [31:0] D_pc;
wire [5:0] D_op;
wire [5:0] D_func;
wire [4:0] D_rs;
wire [4:0] D_rt;
wire [4:0] D_rd;
wire [15:0] D_immediate;
wire [25:0] D_target;
wire [4:0] D_ExcCodeF;
wire D_BD,flush;
FtoD ftod(
	.Instr(Instr),
	.Stall(Stall),
	.clk(clk),
	.reset(reset),
	.flush(flush),
	.Req(Req),
	.F_pc(PCnow),
	.F_ExcCode(F_ExcCode),
	.F_BD(F_BD),
	.D_pc(D_pc),
	.op(D_op),
	.func(D_func),
	.rs(D_rs),
	.rt(D_rt),
	.rd(D_rd),
	.immediate(D_immediate),
	.target(D_target),
	.D_ExcCode(D_ExcCodeF),
	.D_BD(D_BD)
);
/*********D*********/
wire [2:0] D_EXTop;
wire [1:0] rs_Tuse;
wire [1:0] rt_Tuse;
wire [2:0] D_MDop;
wire [1:0] D_HILO_Rop;
wire unknown;
Controller D_control(
	.op(D_op),
	.func(D_func),
	.rs(D_rs),
	.EXTop(D_EXTop),
	.NPCop(D_NPCop),
	.rs_Tuse(rs_Tuse),
	.rt_Tuse(rt_Tuse),
	.MemWrite(),
	.RegWrite(),
	.ALUop(),
	.ALUsrc(),
	.GRFWDop(),
	.GRFWaddrop(),
	.E_Tnew(),
	.M_EXTop(),
	.MDop(D_MDop),
	.HILO_Rop(D_HILO_Rop),
	.unknown(unknown),
	.load(),
	.save(),
	.addsub(),
	.CP0Write()
);

wire [31:0] D_offset;
EXT ext(
	.EXTop(D_EXTop),
	.in(D_immediate),
	.out(D_offset)
);
wire W_RegWrite;
wire [4:0] W_GPRA3;
wire [31:0] W_Data;
wire [31:0] W_pc;
wire [31:0] GPRrs;
wire [31:0] GPRrt;
GRF grf(
	.clk(clk),
	.reset(reset),
	.WE(W_RegWrite),
	.Raddr1(D_rs),
	.Raddr2(D_rt),
	.Waddr(W_GPRA3),
	.WD(W_Data),
	.WPC(W_pc),
	.D1(GPRrs),
	.D2(GPRrt)
);
assign w_grf_we = W_RegWrite;
assign w_grf_addr = W_GPRA3;
assign w_grf_wdata = W_Data;
assign w_inst_addr = W_pc;
wire [1:0] E_Tnew;
wire [1:0] M_Tnew;
wire [1:0] W_Tnew;
wire [4:0] M_GPRA3;
wire [4:0] E_GPRA3;
wire E_RegWrite,M_RegWrite;
wire [2:0] D_rsMUXop;
wire [2:0] D_rtMUXop;
wire [2:0] E_GRFWDop;
wire [2:0] M_GRFWDop;
wire Busy,E_CP0Write,M_CP0Write;
wire [4:0] M_rd;
wire [4:0] E_rd;
wire eret_hazard;
D_Adv_Controller DAcontrol(
	.D_A1(D_rs),
	.D_A2(D_rt),
	.E_Tnew(E_Tnew),
	.M_Tnew(M_Tnew),
	.W_Tnew(W_Tnew),
	.rs_Tuse(rs_Tuse),
	.rt_Tuse(rt_Tuse),
	.M_A3((M_CP0Write == 1'b0) ? M_GPRA3 : M_rd),
	.W_A3(W_GPRA3),
	.E_A3((E_CP0Write == 1'b0) ? E_GPRA3 : E_rd),
	.E_RegWrite(E_RegWrite),
	.M_RegWrite(M_RegWrite),
	.W_RegWrite(W_RegWrite),
	.E_CP0Write(E_CP0Write),
	.M_CP0Write(M_CP0Write),
	.M_GRFWDop(M_GRFWDop),
	.E_GRFWDop(E_GRFWDop),
	.Busy(Busy),
	.D_MDop(D_MDop),
	.D_HILO_Rop(D_HILO_Rop),
	.D_NPCop(D_NPCop),
	.Stall(Stall),
	.rsMUXop(D_rsMUXop),
	.rtMUXop(D_rtMUXop),
	.eret_hazard(eret_hazard)
);
wire [31:0] D_Regrs;
wire [31:0] D_Regrt;
wire [31:0] M_ALUout;
wire [31:0] E_pc;
wire [31:0] M_pc;
wire [31:0] M_Regrt;
Adv_MUX D_AdvMux(
	.GPRrs(GPRrs),
	.GPRrt(GPRrt),
	.M_Data(M_ALUout),
	.W_Data(W_Data),
	.rsMUXop(D_rsMUXop),
	.rtMUXop(D_rtMUXop),
	.E_pc(E_pc),
	.M_pc(M_pc),
	.GPRrsOut(D_Regrs),
	.GPRrtOut(D_Regrt)
);
wire [31:0] EPCout;
wire fflush;
NPC npc(
	.PCnow(D_pc),
	.NPCop(D_NPCop),
	.offset(D_offset),
	.target(D_target),
	.Regrs(D_Regrs),
	.Regrt(D_Regrt),
	.EPC((eret_hazard == 1'b0) ? EPCout : M_Regrt),
	.PCnxt(PCnxt),
	.nxtBD(F_BD),
	.flush(fflush)
);
assign flush = fflush & ~Stall;
wire [4:0] D_ExcCode;
assign D_ExcCode = (D_ExcCodeF != 0) ? D_ExcCodeF :
						 (unknown == 1'b1) ? 10 :
						 (D_op == 6'b000000 && D_func == 6'b001100) ? 8 : 0;
/**********D***********/
wire [31:0] E_GPRrs;
wire [31:0] E_GPRrt;
wire [5:0] E_op;
wire [5:0] E_func;
wire [4:0] E_rs;
wire [4:0] E_rt;
wire [31:0] E_offset;
wire [4:0] E_ExcCodeD;
wire E_BD;
DtoE dtoe(
	 .D_GPRrs(D_Regrs),
    .D_GPRrt(D_Regrt),
    .D_offset(D_offset),
    .D_op(D_op),
    .D_func(D_func),
    .D_rs(D_rs),
    .D_rt(D_rt),
    .D_rd(D_rd),
    .D_pc(D_pc),
	 .D_ExcCode(D_ExcCode),
	 .D_BD(D_BD),
	 .Stall(Stall),
	 .clk(clk),
	 .reset(reset),
	 .Req(Req),
    .E_pc(E_pc),
    .E_GPRrs(E_GPRrs),
    .E_GPRrt(E_GPRrt),
    .E_op(E_op),
    .E_func(E_func),
    .E_rs(E_rs),
    .E_rt(E_rt),
    .E_rd(E_rd),
	 .E_ExcCode(E_ExcCodeD),
    .E_offset(E_offset),
	 .E_BD(E_BD)
);
/*************E**************/
wire ALUsrc;
wire [3:0] ALUop;
wire [2:0] GRFWaddrop;
wire [2:0] E_MDop;
wire [1:0] E_HILO_Rop;
wire E_load,E_save,E_addsub;
Controller E_control(
	.op(E_op),
	.func(E_func),
	.rs(E_rs),
	.E_Tnew(E_Tnew),
	.ALUsrc(ALUsrc),
	.ALUop(ALUop),
	.GRFWaddrop(GRFWaddrop),
	.RegWrite(E_RegWrite),
	.EXTop(),
	.NPCop(),
	.rs_Tuse(),
	.rt_Tuse(),
	.MemWrite(),
	.GRFWDop(E_GRFWDop),
	.M_EXTop(),
	.MDop(E_MDop),
	.HILO_Rop(E_HILO_Rop),
	.unknown(),
	.load(E_load),
	.save(E_save),
	.addsub(E_addsub),
	.CP0Write(E_CP0Write)
);

wire [2:0] E_rsMUXop;
wire [2:0] E_rtMUXop;
E_Adv_Controller EAcontrol(
	.M_Tnew(M_Tnew),
	.W_Tnew(W_Tnew),
	.M_RegWrite(M_RegWrite),
	.W_RegWrite(W_RegWrite),
	.E_A1(E_rs),
	.E_A2(E_rt),
	.W_A3(W_GPRA3),
	.M_A3(M_GPRA3),
	.M_GRFWDop(M_GRFWDop),
	.rsMUXop(E_rsMUXop),
	.rtMUXop(E_rtMUXop)
);

wire [31:0] E_Regrs;
wire [31:0] E_Regrt;
Adv_MUX E_AdvMux(
	.GPRrs(E_GPRrs),
	.GPRrt(E_GPRrt),
	.M_Data(M_ALUout),
	.W_Data(W_Data),
	.rsMUXop(E_rsMUXop),
	.rtMUXop(E_rtMUXop),
	.E_pc(E_pc),
	.M_pc(M_pc),
	.GPRrsOut(E_Regrs),
	.GPRrtOut(E_Regrt)
);

wire [31:0] ALUout;
wire overflow;
ALU alu(
	.ALUop(ALUop),
	.num1(E_Regrs),
	.num2((ALUsrc == 1'b1) ? E_offset : E_Regrt),
	.out(ALUout),
	.overflow(overflow)
);

wire [31:0] MDout;
MULT_DIV md(
	.clk(clk),
	.reset(reset),
	.MDop(E_MDop),
	.HILO_Rop(E_HILO_Rop),
	.num1(E_Regrs),
	.num2((ALUsrc == 1'b1) ? E_offset : E_Regrt),
	.Req(Req),
	.Busy(Busy),
	.HILO_output(MDout)
);

wire [31:0] E_ALUout;
assign E_ALUout = (E_HILO_Rop == 2'b00) ? ALUout : MDout;
GRF_Waddr grf_waddr(
	.rd(E_rd),
	.rt(E_rt),
	.GRFWaddrop(GRFWaddrop),
	.Waddrout(E_GPRA3)
);
wire [4:0] E_ExcCode;
assign E_ExcCode = (E_ExcCodeD != 0) ? E_ExcCodeD :
						 (overflow == 1'b1 && E_addsub == 1'b1) ? 12 :
						 (overflow == 1'b1 && E_load == 1'b1) ? 4 : 
						 (overflow == 1'b1 && E_save == 1'b1) ? 5 : 0;
/**********E*************/
wire [31:0] M_GPRrt;
wire [5:0] M_op;
wire [5:0] M_func;
wire [4:0] M_rt;
wire [4:0] M_rs;
wire [31:0] M_GPRrs;
wire [4:0] M_ExcCodeE;
wire M_BD;
EtoM etom(
	 .E_ALUout(E_ALUout),
    .E_GPRrt(E_Regrt),
    .E_GPRA3(E_GPRA3),
    .E_pc(E_pc),
	 .E_op(E_op),
    .E_func(E_func),
	 .E_Tnew(E_Tnew),
	 .E_rs(E_rs),
	 .E_rt(E_rt),
	 .E_GPRrs(E_Regrs),
	 .E_ExcCode(E_ExcCode),
	 .E_rd(E_rd),
	 .E_BD(E_BD),
    .clk(clk),
    .reset(reset),
	 .Req(Req),
    .M_ALUout(M_ALUout),
    .M_GPRrt(M_GPRrt),
    .M_GPRA3(M_GPRA3),
    .M_pc(M_pc),
	 .M_op(M_op),
	 .M_func(M_func),
	 .M_Tnew(M_Tnew),
	 .M_rs(M_rs),
	 .M_rt(M_rt),
	 .M_ExcCode(M_ExcCodeE),
	 .M_GPRrs(M_GPRrs),
	 .M_rd(M_rd),
	 .M_BD(M_BD)
);
/*******************M***************/
wire [1:0]MemWrite;
wire [2:0] M_EXTop;
wire [2:0] M_NPCop;
wire M_load,M_save;
Controller M_control(
	.op(M_op),
	.func(M_func),
	.rs(M_rs),
	.MemWrite(MemWrite),
	.RegWrite(M_RegWrite),
	.EXTop(),
	.NPCop(M_NPCop),
	.rs_Tuse(),
	.rt_Tuse(),
	.ALUop(),
	.ALUsrc(),
	.GRFWDop(M_GRFWDop),
	.GRFWaddrop(),
	.E_Tnew(),
	.M_EXTop(M_EXTop),
	.MDop(),
	.HILO_Rop(),
	.unknown(),
	.load(M_load),
	.save(M_save),
	.addsub(),
	.CP0Write(M_CP0Write)
);

wire [2:0] M_rsMUXop;
wire [2:0] M_rtMUXop;
M_Adv_Controller MAcontrol(
	.W_Tnew(W_Tnew),
	.W_RegWrite(W_RegWrite),
	.M_A1(M_rs),
	.M_A2(M_rt),
	.W_A3(W_GPRA3),
	.rsMUXop(M_rsMUXop),
	.rtMUXop(M_rtMUXop)
);

wire [31:0] M_Regrs;
Adv_MUX M_AdvMux(
	.GPRrs(M_GPRrs),
	.GPRrt(M_GPRrt),
	.M_Data(M_ALUout),
	.W_Data(W_Data),
	.rsMUXop(M_rsMUXop),
	.rtMUXop(M_rtMUXop),
	.E_pc(E_pc),
	.M_pc(M_pc),
	.GPRrsOut(M_Regrs),
	.GPRrtOut(M_Regrt)
);

wire [31:0] M_MemRD;
assign m_data_addr = M_ALUout;
assign m_data_wdata = (MemWrite == 2'b01) ? M_Regrt : 
							 (MemWrite == 2'b10) ? {M_Regrt[15:0], M_Regrt[15:0]} : 
							 (MemWrite == 2'b11) ? {4{M_Regrt[7:0]}} : M_Regrt;
assign m_data_byteen = (Req == 1'b1) ? 4'b0000 :
							(MemWrite == 2'b01) ? 4'b1111 :
							(MemWrite == 2'b10 && M_ALUout[1] == 1'b0) ? 4'b0011 :
							(MemWrite == 2'b10 && M_ALUout[1] == 1'b1) ? 4'b1100 :
							(MemWrite == 2'b11 && M_ALUout[1:0] == 2'b00) ? 4'b0001 :
							(MemWrite == 2'b11 && M_ALUout[1:0] == 2'b01) ? 4'b0010 :
							(MemWrite == 2'b11 && M_ALUout[1:0] == 2'b10) ? 4'b0100 :
							(MemWrite == 2'b11 && M_ALUout[1:0] == 2'b11) ? 4'b1000 : 4'b0000;
assign m_inst_addr = M_pc;
M_EXT mext(
	.A(M_ALUout[1:0]),
	.Din(m_data_rdata),
	.Op(M_EXTop),
	.Dout(M_MemRD)
);
wire [4:0] M_ExcCode;
wire TimerAddr,M_lb,M_lh,M_lw,NoHit,M_sw,M_sh,M_sb,CountAddr;
assign M_lb = (M_op == 6'b100000) ? 1 : 0;
assign M_lh = (M_op == 6'b100001) ? 1 : 0;
assign M_lw = (M_op == 6'b100011) ? 1 : 0;
assign M_sb = (M_op == 6'b101000) ? 1 : 0;
assign M_sh = (M_op == 6'b101001) ? 1 : 0;
assign M_sw = (M_op == 6'b101011) ? 1 : 0;
assign TimerAddr = ((M_ALUout >= 32'h00007f00 && M_ALUout <= 32'h00007f0b) || (M_ALUout >= 32'h00007f10 && M_ALUout <= 32'h00007f1b)) ? 1 : 0;
assign CountAddr = ((M_ALUout >= 32'h00007f08 && M_ALUout <= 32'h00007f0b) || (M_ALUout >= 32'h00007f18 && M_ALUout <= 32'h00007f1b)) ? 1 : 0;
assign NoHit = ((~TimerAddr) && (M_ALUout >= 32'h00002fff) && !(M_ALUout >= 32'h00007f20 && M_ALUout <= 32'h00007f23)) ? 1 : 0;
assign M_ExcCode = (M_ExcCodeE != 0) ? M_ExcCodeE :
						 ((M_lw && M_ALUout[1:0] != 2'b00) || (M_lh && M_ALUout[0] != 1'b0) || ((M_lh || M_lb) && TimerAddr) || (M_load && NoHit)) ? 4 :
						 ((M_sw && M_ALUout[1:0] != 2'b00) || (M_sh && M_ALUout[0] != 1'b0) || ((M_sh || M_sb) && TimerAddr) || (M_save && (CountAddr || NoHit))) ? 5 : 0;

wire [31:0] M_CP0out;
CP0 cp0(
	.clk(clk),
	.reset(reset),
	.en(M_CP0Write),
	.CP0Add(M_rd),
	.CP0In(M_Regrt),
	.CP0Out(M_CP0out),
	.VPC(M_pc),
	.BDIn(M_BD),
	.ExcCodeIn(M_ExcCode),
	.HWInt({1'b0,1'b0,1'b0,IGout,Timer1out,Timer0out}),
	.EXLClr((M_NPCop == 5) ? 1'b1 : 1'b0),
	.EPCOut(EPCout),
	.Req(Req)
);
/**************M*********************/
wire [31:0] W_MemRD;
wire [31:0] W_ALUout;
wire [5:0] W_op;
wire [5:0] W_func;
wire [31:0] W_CP0out;
wire [4:0] W_rs;
MtoW mtow(
	 .M_MemRD(M_MemRD),
    .M_ALUout(M_ALUout),
    .M_pc(M_pc),
    .M_GPRA3(M_GPRA3),
	 .M_op(M_op),
	 .M_func(M_func),
	 .M_Tnew(M_Tnew),
	 .M_rs(M_rs),
	 .M_CP0out(M_CP0out),
    .clk(clk),
    .reset(reset),
	 .Req(Req),
	 .M_ExcCode(M_ExcCode),
    .W_MemRD(W_MemRD),
    .W_ALUout(W_ALUout),
    .W_pc(W_pc),
    .W_GPRA3(W_GPRA3),
	 .W_op(W_op),
	 .W_func(W_func),
	 .W_Tnew(W_Tnew),
	 .W_rs(W_rs),
	 .W_CP0out(W_CP0out)
);
/***********W*****************/
wire [2:0] GRFWDop;
Controller W_control(
	.op(W_op),
	.func(W_func),
	.rs(W_rs),
	.RegWrite(W_RegWrite),
	.GRFWDop(GRFWDop),
	.EXTop(),
	.NPCop(),
	.rs_Tuse(),
	.rt_Tuse(),
	.MemWrite(),
	.ALUop(),
	.ALUsrc(),
	.GRFWaddrop(),
	.E_Tnew(),
	.M_EXTop(),
	.MDop(),
	.HILO_Rop(),
	.unknown(),
	.load(),
	.save(),
	.addsub(),
	.CP0Write()
);

GRF_WD grfwd(
	.ALUout(W_ALUout),
	.DMout(W_MemRD),
	.PC(W_pc),
	.CP0out(W_CP0out),
	.GRFWDop(GRFWDop),
	.GRFWDout(W_Data)
);
endmodule

