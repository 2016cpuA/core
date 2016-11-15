module operand_fetch #(
	parameter INST_MEM_WIDTH = 2;
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic distinct_before,
	input logic RegWrite_before,
	input logic UART_write_enable,
	input logic [4:0] rs,
	input logic [4:0] rt,
	input logic [4:0] rw,
	input logic [31:0] write_data,
	output logic distinct_next,
	output logic [31:0] op1_sub,
	output logic [31:0] op2_sub

