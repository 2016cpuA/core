module branch(
	input logic [1:0] Branch,
	input logic [31:0] alu_result,
	input logic reset,
	output logic [1:0] PCSrcs,
)
	always_comb begin
		if (reset) begin
			PCSrcs <= 2'b11;
		end
		case (Branch)
			2'b00 : PCSrcs <= 2'b00; //JR
			2'b01 : PCSrcs <= 2'b01; //J,JAL
			2'b10 : if (aluresult) begin //BEQ.BNE
						PCSrcs <= 2'b10;
					end else begin
						PCSrcs <= 2'b11;
					end
			2'b11 : PCSrcs <= 2'b11; //default
		endcase
	end
endmodule
