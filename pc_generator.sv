module pc_generator #(
	parameter WIDTH_G = 2
)(
	input logic [1:0] PCSrcs,
	input logic reset,
	input logic [WIDTH_G-1:0] pc0, //JR
	input logic [WIDTH_G-1:0] pc1, //J, JAL
	input logic [WIDTH_G-1:0] pc2, //BEQ,BNE,default
	input logic [WIDTH_G-1:0] pc3, //BEQ,BNE,default
	input logic enable,
	output logic [WIDTH_G-1:0] pc,
);
	always_comb begin
		if (reset) begin
			pc <= 0;
		end
		if (enable) begin
			case (PCSrcs)
				2'b00 : pc <= pc0;
				2'b01 : pc <= pc3;
				2'b10 : pc <= pc2;
				2'b11 : pc <= pc1;
			endcase
		end
	end
endmodule
	
