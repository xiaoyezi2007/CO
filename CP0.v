`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:24:15 11/19/2024 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
    input clk,
    input reset,
    input en,
    input [4:0] CP0Add,
    input [31:0] CP0In,
    output [31:0] CP0Out,
    input [31:0] VPC,
    input BDIn,
    input [4:0] ExcCodeIn,
    input [5:0] HWInt,
    input EXLClr,
    output [31:0] EPCOut,
    output Req
    );
reg [31:0] SR;
reg [31:0] Cause;
reg [31:0] EPC;
reg req;

always @(posedge clk) begin
	if(reset == 1'b1) begin
		SR <= 0;
		Cause <= 0;
		EPC <= 0;
		req <= 1'b0;
	end
	else if(EXLClr == 1'b1) begin
		SR[1] <= 1'b0;
		Cause[15:10] <= HWInt;
		req <= 1'b0;
	end
	else if(SR[1] == 1'b0 && ((HWInt & SR[15:10]) != 0 && SR[0] == 1'b1)) begin
		Cause[6:2] <= 5'b00000;
		Cause[15:10] <= HWInt;
		if(BDIn == 1'b1) begin
			EPC <= VPC - 4;
		end
		else begin
			EPC <= VPC;
		end
		Cause[31] <= BDIn;
		SR[1] <= 1'b1;
		req <= 1'b1;
	end
	else if(SR[1] == 1'b0 && ExcCodeIn != 0) begin
		Cause[6:2] <= ExcCodeIn;
		Cause[15:10] <= HWInt;
		if(BDIn == 1'b1) begin
			EPC <= VPC - 4;
		end
		else begin
			EPC <= VPC;
		end
		Cause[31] <= BDIn;
		SR[1] <= 1'b1;
		req <= 1'b1;
	end
	else begin
		Cause[15:10] <= HWInt;
		if(en == 1'b1 && CP0Add == 5'd12) begin
			SR <= CP0In;
		end
		else if(en == 1'b1 && CP0Add == 5'd13) begin
			Cause <= CP0In;
		end
		else if(en == 1'b1 && CP0Add == 5'd14) begin
			EPC <= CP0In;
		end
		req <= 1'b0;
	end
end

assign EPCOut = EPC;
assign CP0Out = (CP0Add == 5'd12) ? SR :
					 (CP0Add == 5'd13) ? Cause :
					 (CP0Add == 5'd14) ? EPC : 0;
assign Req = (EXLClr == 1'b0 && SR[1] == 1'b0 && (ExcCodeIn != 0 || ((HWInt & SR[15:10]) != 0 && SR[0] == 1'b1))) ? 1'b1 : 1'b0; 
endmodule
