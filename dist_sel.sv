module dist_sel(
	input logic [1:0] RegDist,
	input logic [4:0] rd,
	input logic [4:0] rt,
	output logic [4:0] rdist
);
	always_comb begin
		case (RegDist)
			2'b00 : rdist <= rd;
			2'b01 : rdist <= rt;
			2'b10 : rdist <= 5'b11111;
			default : rdist <= 5'b00000;
		endcase
	end
endmodule 
