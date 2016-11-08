module memory_access #(
	parameter INST_MEM_WIDTH = 2,
	parameter DATA_MEM_WIDTH = 3
) (
	input logic CLK,
	input logic reset,
 	input logic RegWrite,
	input logic [1:0] MemtoReg,
	input logic [1:0] Branch,
	input logic MemWrite,
	input logic MemRead,
	input logic UARTtoReg,
	input logic [31:0] register_data,
	input logic [31:0] alu_result,
	input logic [4:0] rdist,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic [INST_MEM_WIDTH-1:0] pc2,
 	output logic RegWrite_next,
	output logic [1:0] MemtoReg_next,
	output logic [1:0] Branch_next,
	output logic UARTtoReg_next,
	output logic [31:0] read_data,
	output logic [31:0] register_data_next,
	output logic [31:0] alu_result_next,
	output logic [4:0] rdist_next,
	output logic [25:0] inst_index_next,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next,
	output logic [INST_MEM_WIDTH-1:0] pc2_next
);
	data_memory #(DATA_MEM_WIDTH) data_memory_instance(CLK, reset, alu_result, register_data, MemWrite, read_data, MemRead);

	always_ff @(posedge CLK) begin
		RegWrite_next <= RegWrite;
		MemtoReg_next <= MemtoReg;
		Branch_next <= Branch;
		UARTtoReg_next <= UARTtoReg;
		register_data_next <= register_data;
		alu_data_next <= alu_data;
		rdist_next <= rdist;
		inst_index_next <= inst_index;
		pc_next <= pc;
		pc1_next <= pc1;
		pc2_next <= pc2;
	end
endmodule
