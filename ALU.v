`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:48 10/29/2024 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [3:0] ALUop,
    input [31:0] num1,
    input [31:0] num2,
    output [31:0] out,
	 output overflow
    );
reg [31:0] ans;
reg [32:0] temp;
reg OverFlow;
always @(*) begin
	case(ALUop)
		0:
		begin
			ans = num1 + num2;
			temp = {num1[31],num1} + {num2[31],num2};
			if(temp[32] != temp[31]) begin
				OverFlow = 1'b1;
			end
			else begin
				OverFlow = 1'b0;
			end
		end
		1:
		begin
			ans = num1 - num2;
			temp = {num1[31],num1} - {num2[31],num2};
			if(temp[32] != temp[31]) begin
				OverFlow = 1'b1;
			end
			else begin
				OverFlow = 1'b0;
			end
		end
		2:
		begin
			ans = num1 | num2;
			OverFlow = 1'b0;
		end
		3:
		begin
			ans = num1 & num2;
			OverFlow = 1'b0;
		end
		4:
		begin
			ans = ($signed(num1) < $signed(num2)) ? 1 : 0;
			OverFlow = 1'b0;
		end
		5:
		begin
			ans = (num1 < num2) ? 1 : 0;
			OverFlow = 1'b0;
		end
	endcase
end
assign out = ans;
assign overflow = OverFlow;
endmodule
