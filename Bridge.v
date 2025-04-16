`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:45 11/19/2024 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    input [3:0] WeCPU,
    input [31:0] Addr,
    input [31:0] WD,
    input [31:0] RDDM,
    input [31:0] RDT0,
    input [31:0] RDT1,
    output [3:0] WeIG,
    output [3:0] WeDM,
    output WeT0,
    output WeT1,
    output [31:0] Waddr,
    output [31:0] WDout,
	 output [31:0] RDCPU
    );

wire HitIG,HitDM,HitT0,HitT1;
assign HitDM = (Addr <= 32'h00002fff) ? 1 : 0;
assign HitIG = (Addr >= 32'h00007f20 && Addr <= 32'h00007f23) ? 1 : 0;
assign HitT0 = (Addr >= 32'h00007f00 && Addr <= 32'h00007f0b) ? 1 : 0;
assign HitT1 = (Addr >= 32'h00007f10 && Addr <= 32'h00007f1b) ? 1 : 0;

assign WeIG = WeCPU & {HitIG, HitIG, HitIG, HitIG};
assign WeDM = WeCPU & {HitDM, HitDM, HitDM, HitDM};
assign WeT0 = WeCPU[0] & HitT0;
assign WeT1 = WeCPU[0] & HitT1;
assign WDout = WD;
assign Waddr = Addr;

assign RDCPU = (HitDM == 1'b1) ? RDDM :
					(HitT0 == 1'b1) ? RDT0 :
					(HitT1 == 1'b1) ? RDT1 : 0;

endmodule
