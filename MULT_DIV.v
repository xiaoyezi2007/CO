`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:46:02 11/13/2024 
// Design Name: 
// Module Name:    MULT_DIV 
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
module MULT_DIV(
    input clk,
    input reset,
	 input [2:0] MDop,
	 input [1:0] HILO_Rop,
    input [31:0] num1,
    input [31:0] num2,
	 input Req,
    output Busy,
    output [31:0] HILO_output
    );

reg [4:0] cnt;
reg [31:0] HI;
reg [31:0] LO;
always@(posedge clk) begin
	if(reset == 1'b1) begin
		cnt = 0;
		HI = 0;
		LO = 0;
	end
	else begin
		if(cnt == 0 && Req == 1'b0) begin
			case(MDop)
				1:
				begin
					{HI, LO} = $signed(num1) * $signed(num2);
					cnt = 5;
				end
				2:
				begin
					{HI, LO} = num1 * num2;
					cnt = 5;
				end
				3:
				begin
					LO = $signed(num1) / $signed(num2);
					HI = $signed(num1) % $signed(num2);
					cnt = 10;
				end
				4:
				begin
					LO = num1 / num2;
					HI = num1 % num2;
					cnt = 10;
				end
				5:
				begin
					HI = num1;
					cnt = 0;
				end
				6:
				begin
					LO = num1;
					cnt = 0;
				end
			endcase
		end
		else if(cnt != 0) begin
			cnt = cnt - 1;
		end
	end
end
assign HILO_output = (HILO_Rop == 2'b01 && cnt == 0) ? HI :
							(HILO_Rop == 2'b10 && cnt == 0) ? LO : 0;
assign Busy = (cnt != 0 || MDop != 3'b000) ? 1 : 0;
endmodule
