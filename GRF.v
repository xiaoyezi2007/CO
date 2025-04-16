`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:59:44 10/29/2024 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input clk,
    input reset,
    input WE,
    input [4:0] Raddr1,
    input [4:0] Raddr2,
    input [4:0] Waddr,
    input [31:0] WD,
	 input [31:0] WPC,
    output [31:0] D1,
    output [31:0] D2
    );
reg [31:0] grf [0:31];
integer i;
always @(posedge clk) begin
	if(reset == 1) begin
		for(i = 0;i < 32;i = i + 1) begin
			grf[i] <= 0;
		end
	end
	else begin
		if(WE == 1 && Waddr != 0) begin
			grf[Waddr] <= WD;
		end
		else begin
			grf[Waddr] <= grf[Waddr];
		end
	end
end
assign D1 = grf[Raddr1];
assign D2 = grf[Raddr2];
endmodule
