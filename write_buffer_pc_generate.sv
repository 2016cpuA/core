module write_buffer_pc_generate #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic distinct,
	input logic RegWrite,
	input logic [1:0] MemtoReg,
	input logic [1:0] Branch,
	input logic UARTtoReg,
	input logic [31:0] read_data,
	input logic [31:0] register_data,
	input logic [31:0] alu_result,
	input logic [4:0] rd,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic [INST_MEM_WIDTH-1:0] pc2,
	input logic input_ready,
	input logic [31:0] input_data,
	output logic distinct_next,
	output logic RegWrite_next,
	output logic UART_write_enable,
	output logic [31:0] data,
	output logic [4:0] rd_next,
	output logic [INST_MEM_WIDTH-1:0] pc_generated,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);
	logic pc_enable;
	logic [1:0] PCSrcs;

	branch branch_instance(Branch, alu_result, PCSrcs);
	register_write #(INST_MEM_WIDTH) register_write_instance(MemtoReg, UARTtoReg, read_data, alu_result, pc, input_data, input_ready, UART_write_enable, pc_enable, data);
	pc_generator #(INST_MEM_WIDTH) pc_generator_instance(PCSrcs, register_data[INST_MEM_WIDTH-1:0], inst_index[INST_MEM_WIDTH-1:0], pc2, pc1, pc_enable, pc_generated);
	pc_adder pc_adder_instance(pc_generated, 1, pc1_next);

	always_comb begin
		distinct_next <= distinct;
		RegWrite_next <= RegWrite;
		rd_next <= rd;
	end
endmodule
	
