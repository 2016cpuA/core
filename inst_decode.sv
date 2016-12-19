module inst_decode #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK,
	input logic reset,
	input logic inst_enable,
	input logic distinct,
	input logic [31:0] inst,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	output logic distinct_next,
 	output logic RegWrite,
	output logic [1:0] MemtoReg,
	output logic [1:0] ALUSrcs,
	output logic ALUSrcs2,
	output logic [3:0] ALUOp,
	output logic [1:0] RegDist,
	output logic [1:0] Branch,
	output logic MemWrite,
	output logic MemRead,
	output logic UARTtoReg,
	output logic RegtoUART,
	output logic [4:0] rs,
	output logic [4:0] rt,
	output logic [4:0] rd,
	output logic [4:0] sa,
	output logic [15:0] immediate,
	output logic [25:0] inst_index,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);
	logic [5:0] opcode;
	logic [5:0] funct;
	logic [31:0] inst_;
	logic [1:0] state;

	inst_decoder inst_decoder_instance(
			inst_, 
			opcode, 
			rs, 
			rt, 
			rd, 
			sa,
			funct, 
			immediate, 
			inst_index
	);
	operator operator_instamce(
			opcode, 
			funct, 
			RegWrite, 
			MemtoReg, 
			ALUSrcs, 
			ALUSrcs2, 
			ALUOp, 
			RegDist, 
			Branch, 
			MemWrite, 
			MemRead, 
			UARTtoReg, 
			RegtoUART
	);
	always_ff @(posedge CLK) begin
		if (reset) begin
			inst_ <= 0;
			distinct_next <= 0;
			pc_next <= 0;
			pc1_next <= 0;
			state <= 0;
		end else begin
			if (inst_enable && state == 0) begin
				state <= state + 1;
			end	else if(state == 1) begin
				state <= state + 1;
			end else begin
				distinct_next <= distinct;
				pc_next <= pc;
				pc1_next <= pc1;
				inst_ <= inst;
				state <= 0;
			end
		end
	end
endmodule
