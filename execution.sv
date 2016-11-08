module execution #(
	parameter INST_MEM_WIDTH = 2
) (
 	input logic RegWrite,
	input logic [1:0] MemtoReg,
	input logic [1:0] ALUSrcs,
	input logic ALUSrcs2,
	input logic [3:0] ALUOp,
	input logic [1:0] RegDist,
	input logic [1:0] Branch,
	input logic MemWrite,
	input logic MemRead,
	input logic UARTtoReg,
	input logic RegtoUART,
	input logic [31:0] op1_sub,
	input logic [31:0] op2_sub,
	input logic [4:0] rt,
	input logic [4:0] rd,
	input logic [4:0] sa,
	input logic [15:0] immediate,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
 	output logic RegWrite_next,
	output logic [1:0] MemtoReg_next,
	output logic [1:0] Branch_next,
	output logic MemWrite_next,
	output logic MemRead_next,
	output logic UARTtoReg_next,
	output logic [31:0] register_data,
	output logic [31:0] alu_result,
	output logic [4:0] rdist,
	output logic [25:0] inst_index_next,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next,
	output logic [INST_MEM_WIDTH-1:0] pc2
);
	logic [31:0] op1;
	logic [31:0] op2;

	op1_sel op1_sel_instance(ALUSrcs2, op1_sub, op2_sub, op1);
	op2_sel op2_sel_instance(ALUSrcs, op2_sub, sa, immediate, op2);
	dist_sel dist_sel_instance(RegDist, rd, rt, rdist);
	pc_adder pc_adder2_instance(pc, immediate[INST_MEM_WIDTH-1:0], pc2);
	alu alu_instance(ALUOp, op1, op2, alu_result);
	
	always_comb begin
		RegWrite_next <= RegWrite;
		MemtoReg_next <= MemtoReg;
		Branch_next <= Branch;
		MemWrite_next <= MemWrite;
		MemRead_next <= MemRead;
		UARTtoReg_next <= UARTtoReg;
		register_data <= op1_sub;
		inst_index_next <= inst_index;
		pc_next <= pc;
		pc1_next <= pc1;
	end
endmodule
	
