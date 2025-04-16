`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:50:28 10/29/2024 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [2:0] EXTop,
    input [15:0] in,
    output [31:0] out
    );
reg [31:0] ans;
always @(*) begin
	case(EXTop)
		0:
		begin
			ans = (in[15] == 1'b1) ? {{16{1'b1}}, in} : {{16{1'b0}}, in};
		end
		1:
		begin
			ans = {{16{1'b0}}, in};
		end
		2:
		begin
			ans = {in, {16{1'b0}}};
		end
		3:
		begin
			ans = (in[15] == 1'b1) ? {{14{1'b1}}, in, 2'b00} : {{14{1'b0}}, in, 2'b00};
		end
	endcase
end
assign out = ans;
endmodule
