module inst_fetch #(//前提：loader_ready = input_validは一瞬しか上がらない
	parameter INST_MEM_WIDTH = 2
) (
//	output logic flag,
	input logic CLK, 
	input logic reset,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic [31:0] input_data, //program loader
	input logic input_start, //program loader
	input logic input_end, //program loader
	input logic input_valid,//prorgram loader
	output logic distinct,
	output logic [31:0] inst,
	output logic inst_enable,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
//	output logic [7:0] led
);
	logic [31:0] loader_data;
	logic loader_enable;
	logic loader_ready;
	logic [31:0] input_data_buf;
	logic input_valid_buf;

	inst_memory #(INST_MEM_WIDTH) inst_memory_instance(
	       CLK, 
	       reset, 
	       pc, 
	       loader_data, 
	       loader_enable, 
	       loader_ready,
	       inst, 
		   distinct
//		   led
	);

	always_ff @(posedge CLK) begin
		if (reset) begin //initialize
			pc_next <= 0;
			pc1_next <= 0;
			inst_enable <= 1;
			loader_enable <= 0;
			loader_data <= 32'hffffffff;
			loader_ready <= 0;
			input_data_buf <= 0;
			input_valid_buf <= 0;
//			led <= 8'b01010101;
		end else begin
//			led[0] <= input_data[31];
//			led[1] <= input_data[30];
//			led[2] <= input_data[29];
//			led[3] <= input_data[28];
//			led[4] <= input_data[27];
//			led[5] <= input_data[26];
//			led[6] <= input_data[25];
//			if (input_valid) begin
//				led[7] <= 1;
//			end
			pc_next <= pc;
			pc1_next <= pc1;
		end

		if (input_start) begin //program loader
			loader_enable <= 1;
			inst_enable <= 0;
		end else if (input_end) begin
			loader_enable <= 0;
			inst_enable <= 1;
			loader_ready <= 0;
		end else if (loader_enable) begin
			loader_data <= input_data_buf;
			loader_ready <= input_valid_buf;
		end
		
		if (input_valid_buf != input_valid) begin
			input_data_buf <= input_data;
			input_valid_buf <= input_valid;
		end
	end
endmodule

