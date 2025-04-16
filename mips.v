`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:05 11/24/2024 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset,
    input interrupt,
    output [31:0] macroscopic_pc,
    output [31:0] i_inst_addr,
    input [31:0] i_inst_rdata,
    output [31:0] m_data_addr,
    input [31:0] m_data_rdata,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_int_addr,
    output [3:0] m_int_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
    );

wire [31:0] CPUaddr;
wire [3:0] CPUwe;
wire [31:0] CPUdata;
wire [31:0] T0data;
wire [31:0] T1data;
wire [31:0] DMdata;
wire [31:0] WDout;
wire [31:0] Waddr;
wire [31:0] CPURD;
wire T0out,T1out;
wire WeT0,WeT1;
wire [3:0] WeIG;
wire [3:0] WeDM;
CPU cpu(
	.clk(clk),
	.reset(reset),
	.i_inst_rdata(i_inst_rdata),
	.m_data_rdata(CPURD),
	.Timer0out(T0out),
	.Timer1out(T1out),
	.IGout(interrupt),
	.i_inst_addr(i_inst_addr),
	.m_data_addr(CPUaddr),
	.m_data_wdata(CPUdata),
	.m_data_byteen(CPUwe),
	.m_inst_addr(m_inst_addr),
	.w_grf_we(w_grf_we),
	.w_grf_addr(w_grf_addr),
	.w_grf_wdata(w_grf_wdata),
	.w_inst_addr(w_inst_addr)
);

Bridge bridge(
	.WeCPU(CPUwe),
	.Addr(CPUaddr),
	.WD(CPUdata),
	.RDDM(DMdata),
	.RDT0(T0data),
	.RDT1(T1data),
	.WeIG(WeIG),
	.WeT0(WeT0),
	.WeT1(WeT1),
	.WeDM(WeDM),
	.Waddr(Waddr),
	.WDout(WDout),
	.RDCPU(CPURD)
);

assign m_data_addr = Waddr;
assign m_data_wdata = WDout;
assign DMdata =  m_data_rdata;
assign m_data_byteen = WeDM;
assign m_int_addr = Waddr;
assign m_int_byteen = WeIG;
assign macroscopic_pc = m_inst_addr;

TC timer0(
	.clk(clk),
	.reset(reset),
	.Addr(Waddr[31:2]),
	.WE(WeT0),
	.Din(WDout),
	.Dout(T0data),
	.IRQ(T0out)
);

TC timer1(
	.clk(clk),
	.reset(reset),
	.Addr(Waddr[31:2]),
	.WE(WeT1),
	.Din(WDout),
	.Dout(T1data),
	.IRQ(T1out)
);
endmodule
