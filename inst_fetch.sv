module inst_fetch #(//前提：loader_ready = input_validは一瞬しか上がらない
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK, 
	input logic reset,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic input_start,
	input logic input_end,
	output logic distinct,
	output logic [31:0] inst,
	output logic inst_enable,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);
	inst_memory #(INST_MEM_WIDTH) inst_memory_instance(
	       CLK, 
	       reset, 
	       pc, 
	       inst, 
		   distinct
	);

	always_ff @(posedge CLK) begin
		if (reset) begin //initialize
			pc_next <= 0;
			pc1_next <= 0;
			inst_enable <= 1;
		end else begin
			pc_next <= pc;
			pc1_next <= pc1;
		end
		if (input_start) begin //program loader
			inst_enable <= 0;
		end else if (input_end) begin
			inst_enable <= 1;
		end
	end
endmodule

