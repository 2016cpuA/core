module inst_fetch #(//前提：loader_ready = input_validは一瞬しか上がらない
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK, 
	input logic reset,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic [7:0] input_data, //program loader
	input logic input_start, //program loader
	input logic input_end, //program loader
	input logic input_valid,//prorgram loader
	output logic distinct,
	output logic [31:0] inst,
	output logic inst_enable,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);
	logic [7:0] loader_data;
	logic loader_enable;
	logic loader_ready;
	
	inst_memory #(INST_MEM_WIDTH) inst_memory_instance(
	       CLK, 
	       reset, 
	       pc, 
	       loader_data, 
	       loader_enable, 
	       inst, 
		   distinct,
	       loader_ready
	);

	always_ff @(posedge CLK) begin
		if (reset) begin //initialize
			pc_next <= 0;
			pc1_next <= 0;
			inst_enable <= 1;
			loader_enable <= 0;
		end else begin
			pc_next <= pc;
			pc1_next <= pc1;
		end
		if (input_start) begin //program loader
			loader_enable <= 1;
			inst_enable <= 0;
		end else if (input_end) begin
			loader_enable <= 0;
			inst_enable <= 1;
		end else if (loader_enable) begin
			loader_data <= input_data;
			loader_ready <= input_valid;;
		end
	end
endmodule

