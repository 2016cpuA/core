module inst_decode #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic reset,
	input logic [31:0] inst,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic RegWrite_before,
	input logic UART_write_enable,
	input logic [31:0] data,
	input logic [4:0] address,
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
	output logic [31:0] op1,
	output logic [31:0] op2,
	output logic [4:0] rt,
	output logic [4:0] rd,
	output logic [4:0] sa,
	output logic [15:0] immediate,
	output logic [25:0] inst_index,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);
	logic [5:0] opcode;
	logic [4:0] rs;
	logic [5:0] funct;

	inst_decoder inst_decoder_instance(
			inst, 
			opcode, 
			rs, 
			rt, 
			rd, 
			sa,
			funct, 
			immediate, 
			inst_index
	);
	register register_instance(
			RegWrite_before, 
			UART_write_enable, 
			rs, 
			rt, 
			address, 
			data, 
			reset,
			op1, 
			op2
	);
	operator operator_instamce(
			opcode, 
			funct, 
			reset, 
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
	always_comb begin
		pc_next <= pc;
		pc1_next <= pc1;
	end
endmodule
