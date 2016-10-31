module dist_sel(
	input [1:0] RegDist,
	input [4:0] rd,
	input [4:0] rt,
	output [4:0] rdist
)
	always_comb begin
		case (RegDist)
			1'b00 : rdist <= rd;
			1'b01 : rdist <= rt;
			1'b10 : rdist <= 5'b11111;
			default : ;
		endcase
	end
endmodule 
