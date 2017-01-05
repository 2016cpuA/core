module inst_fetch #(
	parameter INST_MEM_WIDTH = 15
) (
	input logic CLK, 
	input logic reset,
	input logic distinct_before,
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
	logic [31:0] inst_;
    logic distinct_;
    logic [INST_MEM_WIDTH-1:0] pc_;
    logic [INST_MEM_WIDTH-1:0] pc1_;
    logic [1:0] state;

	inst_memory #(INST_MEM_WIDTH) inst_memory_instance(
	       CLK, 
	       reset, 
	       pc_, 
	       inst_, 
		   distinct_
	);

	always_ff @(posedge CLK) begin
		if (reset) begin //initialize
			pc_next <= 0;
			pc1_next <= 0;
			inst_enable <= 1;
			pc_ <= 0;
			pc1_ <= 1;
			inst <= 0;
			distinct <= 0;
			state <= 1;
		end else begin
			if (state == 0 && distinct_before) begin
				pc_ <= pc;
				pc1_ <= pc1;
				state <= state + 1;
				distinct <= 0;
			end else if (state == 1) begin
				state <= state + 1;
			end else if (state == 2) begin
				state <= state + 1;
			end else if (state == 3) begin
				inst <= inst_;
				distinct <= distinct_;
				pc_next <= pc_;
				pc1_next <= pc1_;
				state <= 0;
			end else begin
				distinct <= 0;
			end
		end
		if (input_start) begin
			inst_enable <= 0;
		end else if (input_end) begin
			inst_enable <= 1;
		end
	end
endmodule

