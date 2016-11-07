module inst_fetch #(
	parameter INST_MEM_WIDTH = 2
);
	logic CLK, 
	logic reset,
	logic pc,
	logic pc1,
	logic input_data, //program loader
	logic input_start, //program loader
	logic input_end, //program loader
	logic input_valid,//prorgram loader
	logic [31:0] inst,
	logic inst_enable,
	logic [INST_MEM_WIDTH-1:0] pc_next,
	logic [INST_MEM_WIDTH-1:0] pc1_next

	logic [7:0] loader_data;
	logic loader_enable;
	logic loader_ready;
	
	inst_fetch #(INST_MEM_WIDTH) (
		CLK,
		reset,
		pc,
		pc1,
		input_data,
		input_start,
		input_end,
		input_valid,
		inst,
		inst_enable,
		pc_next,
		pc1_next
	);

	always begin
		CLK <= 1;
		#0.5;
		CLK <= 0;
		#0.5;
	end
	
	initial begin
endmodle
