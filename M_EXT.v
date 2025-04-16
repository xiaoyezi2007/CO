`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:59:06 11/13/2024 
// Design Name: 
// Module Name:    M_EXT 
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
module M_EXT(
    input [1:0] A,
    input [31:0] Din,
    input [2:0] Op,
    output [31:0] Dout
    );
reg [31:0] ans;
always@(*) begin
	if(Op == 3'b000) begin
		ans = Din;
	end
	else if(Op == 3'b001) begin
		if(A == 2'b00) begin
			ans = {{24{1'b0}},Din[7:0]};
		end
		else if(A == 2'b01) begin
			ans = {{24{1'b0}},Din[15:8]};
		end
		else if(A == 2'b10) begin
			ans = {{24{1'b0}},Din[23:16]};
		end
		else if(A == 2'b11) begin
			ans = {{24{1'b0}},Din[31:24]};
		end
	end
	else if(Op == 3'b010) begin
		if(A == 2'b00) begin
			ans = {{24{Din[7]}},Din[7:0]};
		end
		else if(A == 2'b01) begin
			ans = {{24{Din[15]}},Din[15:8]};
		end
		else if(A == 2'b10) begin
			ans = {{24{Din[23]}},Din[23:16]};
		end
		else if(A == 2'b11) begin
			ans = {{24{Din[31]}},Din[31:24]};
		end
	end
	else if(Op == 3'b011) begin
		if(A == 2'b00 || A == 2'b01) begin
			ans = {{16{1'b0}},Din[15:0]};
		end
		else begin
			ans = {{16{1'b0}},Din[31:16]};
		end
	end
	else if(Op == 3'b100) begin
		if(A == 2'b00 || A == 2'b01) begin
			ans = {{16{Din[15]}},Din[15:0]};
		end
		else begin
			ans = {{16{Din[31]}},Din[31:16]};
		end
	end
end

assign Dout = ans;
endmodule
