`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:06:50 10/29/2024 
// Design Name: 
// Module Name:    GRF_Waddr 
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
module GRF_Waddr(
    input [4:0] rd,
    input [4:0] rt,
    input [2:0] GRFWaddrop,
    output [4:0] Waddrout
    );
reg[4:0] out;
always@(*) begin
	case(GRFWaddrop)
		0:
		begin
			out = rd;
		end
		1:
		begin
			out = rt;
		end
		2:
		begin
			out = 5'd31;
		end
	endcase
end
assign Waddrout = out;
endmodule
