`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:16:22 10/29/2024 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
    input [5:0] op,
    input [5:0] func,
	 input [4:0] rs,
    output [1:0] MemWrite,
    output RegWrite,
    output [2:0] EXTop,
    output ALUsrc,
    output [3:0] ALUop,
	 output [2:0] NPCop,
	 output [2:0] GRFWDop,
	 output [2:0] GRFWaddrop,
	 output [1:0] rs_Tuse,
	 output [1:0] rt_Tuse,
	 output [1:0] E_Tnew,
	 output [2:0] M_EXTop,
	 output [2:0] MDop,
	 output [1:0] HILO_Rop,
	 output unknown,
	 output load,
	 output save,
	 output addsub,
	 output CP0Write
    );
wire special,COP0;
wire add,sub,ori,lw,sw,beq,lui,jal,jr,And,Or,slt,sltu,andi,addi,bne,sh,lb,lh,mult,multu,div,divu,mfhi,mflo,mthi,mtlo,sb,syscall,mfc0,mtc0,eret;
wire ALUop0,ALUop1,ALUop2,EXTop0,EXTop1,NPCop0,NPCop1,NPCop2,GRFWDop0,GRFWDop1,GRFWaddr0,GRFWaddr1,E_Tnew1,E_Tnew0,
		M_EXTop0,M_EXTop1,M_EXTop2,rs_Tuse0,rs_Tuse1,rt_Tuse0,rt_Tuse1,MemWrite1,MemWrite0,MDop2,MDop1,MDop0;

assign special = ~(|op);
assign COP0 = (op == 6'b010000) ? 1 : 0;

assign add = (special & func == 6'b100000) ? 1 : 0;
assign And = (special & func == 6'b100100) ? 1 : 0;
assign sub = (special & func == 6'b100010) ? 1 : 0;
assign Or  = (special & func == 6'b100101) ? 1 : 0;
assign jr  = (special & func == 6'b001000) ? 1 : 0;
assign slt = (special & func == 6'b101010) ? 1 : 0;
assign sltu= (special & func == 6'b101011) ? 1 : 0;
assign mult= (special & func == 6'b011000) ? 1 : 0;
assign multu=(special & func == 6'b011001) ? 1 : 0;
assign div = (special & func == 6'b011010) ? 1 : 0;
assign divu= (special & func == 6'b011011) ? 1 : 0;
assign mfhi= (special & func == 6'b010000) ? 1 : 0;
assign mflo= (special & func == 6'b010010) ? 1 : 0;
assign mthi= (special & func == 6'b010001) ? 1 : 0;
assign mtlo= (special & func == 6'b010011) ? 1 : 0;
assign syscall = (special & func == 6'b001100) ? 1 : 0;
assign mfc0= (COP0 & rs == 5'b00000) ? 1 : 0;
assign mtc0= (COP0 & rs == 5'b00100) ? 1 : 0;
assign eret= (COP0 & func == 6'b011000) ? 1 : 0;
assign ori = (op == 6'b001101) ? 1 : 0;
assign lw  = (op == 6'b100011) ? 1 : 0;
assign sw  = (op == 6'b101011) ? 1 : 0;
assign beq = (op == 6'b000100) ? 1 : 0;
assign lui = (op == 6'b001111) ? 1 : 0;
assign jal = (op == 6'b000011) ? 1 : 0;
assign addi= (op == 6'b001000) ? 1 : 0;
assign andi= (op == 6'b001100) ? 1 : 0;
assign bne = (op == 6'b000101) ? 1 : 0;
assign sh  = (op == 6'b101001) ? 1 : 0;
assign lb  = (op == 6'b100000) ? 1 : 0;
assign lh  = (op == 6'b100001) ? 1 : 0;
assign sb  = (op == 6'b101000) ? 1 : 0;
assign unknown = ~(mtc0 | mfc0 | eret | syscall | add | And | sub | Or | jr | slt | sltu | mult | multu | div | divu | mfhi | mflo | mthi | mtlo | ori | lw | sw | beq | lui | jal | addi | andi | bne | sh | sb | lh | lb | (special & func == 6'b000000));
assign load = lw | lb | lh;
assign save = sw | sb | sh;
assign addsub = add | addi | sub;


assign MemWrite0 = sw | sb;
assign MemWrite1 = sh | sb;
assign RegWrite = add | sub | ori | lw | lui | jal | And | Or | slt | sltu | addi | andi | lb | lh | mfhi | mflo | mfc0;
assign EXTop0 = ori | beq | andi | bne;
assign EXTop1 = beq | lui | bne;
assign ALUsrc = ori | lw  | sw  | lui | addi | andi | sh | lb | lh | sb;
assign NPCop0 = beq | jr | eret;
assign NPCop1 = jal | jr;
assign NPCop2 = bne | eret;
assign ALUop0 = sub | And | sltu | andi;
assign ALUop1 = ori | And | Or | andi;
assign ALUop2 = slt | sltu;
assign GRFWDop0 = lw | lb | lh | mfc0;
assign GRFWDop1 = jal | mfc0;
assign GRFWaddr0 = ori | lw  | lui | addi | andi | lb | lh | mfc0;
assign GRFWaddr1 = jal;
assign rs_Tuse0 = add | sub | ori | lw | sw | And | Or | slt | sltu | addi | andi | sh | lb | lh | mult | multu | div | divu | mtlo | mthi | sb             | lui | jal | mfhi | mflo | mfc0 | eret | syscall | mtc0;
assign rs_Tuse1 = lui | jal | mfhi | mflo | mfc0 | eret | syscall | mtc0;
assign rt_Tuse0 = add | sub | And | Or | slt | sltu | mult | multu | div | divu                | ori | lui | lw | jal | jr | addi | andi | lb | lh | mfhi | mflo | mtlo | mthi | mfc0 | eret | syscall;
assign rt_Tuse1 = sw | sh | sb | mtc0             | ori | lui | lw | jal | jr | addi | andi | lb | lh | mfhi | mflo | mtlo | mthi | mfc0 | eret | syscall;
assign E_Tnew1 = lw | lb | lh | mfc0;
assign E_Tnew0 = add | sub | And | ori | lui | Or | slt | sltu | addi | andi | mfhi | mflo; 
assign M_EXTop0 = 1'b0;
assign M_EXTop1 = lb;
assign M_EXTop2 = lh;
assign MDop2 = mthi | mtlo | divu;
assign MDop1 = multu | div | mtlo;
assign MDop0 = mult | div | mthi;
assign HILO_Rop = (mfhi) ? 2'b01 :
						(mflo) ? 2'b10 : 2'b00;
assign CP0Write = mtc0;

assign ALUop = {1'b0, ALUop2, ALUop1, ALUop0};
assign EXTop = {1'b0, EXTop1, EXTop0};
assign NPCop = {NPCop2, NPCop1, NPCop0};
assign GRFWDop = {1'b0, GRFWDop1, GRFWDop0};
assign GRFWaddrop = {1'b0, GRFWaddr1, GRFWaddr0};
assign E_Tnew = {E_Tnew1, E_Tnew0};
assign rs_Tuse = {rs_Tuse1,rs_Tuse0};
assign rt_Tuse = {rt_Tuse1,rt_Tuse0};
assign MemWrite = {MemWrite1,MemWrite0};
assign M_EXTop = {M_EXTop2,M_EXTop1,M_EXTop0};
assign MDop = {MDop2,MDop1,MDop0};

endmodule
