module alu (
	input logic CLK,
	input logic [5:0] funct,
	input logic alu_enable,
	input logic [4:0] rs,
	input logic [4:0] rt,
	input logic [4:0] sa,
	output logic [4:0] rd,
	output logic alu_valid
);
	localparam FUNCT_SLL = 6'b000000;
	localparam FUNCT_SRL = 6'b000010;
	localparam FUNCT_SRA = 6'b000011;
	localparam FUNCT_JR  = 6'b001000;
	localparam FUNCT_ADD = 6'b100000;
	localparam FUNCT_SUB = 6'b100010;
	localparam FUNCT_AND = 6'b100100;
	localparam FUNCT_OR  = 6'b100101;
	localparam FUNCT_XOR = 6'b100110;
	localparam FUNCT_SLT = 6'b101010;

	integer state = 0;
	
	always @(posedge CLK) begin
		if (state == 0) begin
			case (funct)
				FUNCT_SLL : begin
								;
							end
				FUNCT_SRL : begin
								;
							end
				FUNCT_SRA : begin
								;
							end
		 		FUNCT_JR  : begin
								;
							end
				FUNCT_ADD : begin
								;
							end
				FUNCT_SUB : begin
								;
							end
				FUNCT_AND : begin
								;
							end
				FUNCT_OR  : begin
								;
							end
				FUNCT_XOR : begin
								;
							end
				FUNCT_SLT : begin
								;
							end
			endcase
		end
	end
endmodule
