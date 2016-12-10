module inst_memory #( //前提：loader_readyは一瞬しか上がらない
	parameter INST_MEM_WIDTH = 2
) (
//	output logic flag,
	input logic CLK,
	input logic reset,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [31:0] loader_data,
	input logic loader_enable,
	input logic loader_ready,
	output logic [31:0] inst,
	output logic distinct,
	output logic [7:0] led
);
	logic [31:0] inst_mem [2**INST_MEM_WIDTH-1:0];// = '{
//		default : 32'h08000000
//	};
	logic [31:0] loader_buf;
	logic [INST_MEM_WIDTH-1:0] loader_index;
	logic [INST_MEM_WIDTH-1:0] pc_buffer;
	logic [2:0] state;
	integer i;
//	logic [7:0] order_change;
	
//	assign order_change[0] = loader_data[7];
//	assign order_change[1] = loader_data[6];
//	assign order_change[2] = loader_data[5];
//	assign order_change[3] = loader_data[4];
//	assign order_change[4] = loader_data[3];
//	assign order_change[5] = loader_data[2];
//	assign order_change[6] = loader_data[1];
//	assign order_change[7] = loader_data[0];

//	assign order_change = loader_data;

	always_ff @(posedge CLK) begin
		if (reset) begin
			loader_index <= 0;
			state <= 0;
			pc_buffer <= 0; //1 ha yabai kamo
			distinct <= 1;
			for (i = 0;i < 2**INST_MEM_WIDTH; i = i + 1) begin
				inst_mem[i] <= 32'h08000000;
			end
//			inst_mem[0] <= 32'hec000000;
//			inst_mem[1] <= 32'hf0000000;
			led <= 0;
			inst <= inst_mem[0];
		end else begin
			if (state == 0) begin
				if (pc != pc_buffer) begin
					distinct <= 1;
					pc_buffer <= pc;
				end else begin
					distinct <= 0;
				end
   				inst <= inst_mem[pc];
				if (loader_enable) begin
					state <= state + 1;
				end
				led[0] <= inst_mem[0][31];
				led[1] <= inst_mem[0][30];
				led[2] <= inst_mem[0][29];
				led[3] <= inst_mem[0][28];
				led[4] <= inst_mem[0][27];
				led[5] <= inst_mem[0][26];
				led[6] <= inst_mem[0][25];
				led[7] <= inst_mem[0][24];
			end else if (state == 1 && loader_ready && loader_enable) begin
				inst_mem[loader_index] <= loader_data;
				loader_index <= loader_index + 1;
			end else if (state == 1 && !loader_enable) begin 
				state <= 0;
			end else begin
				led[0] <= loader_data[31];
				led[1] <= loader_data[30];
				led[2] <= loader_data[29];
				led[3] <= loader_data[28];
				led[4] <= loader_data[27];
				led[5] <= loader_data[26];
				led[6] <= loader_data[25];
				led[7] <= loader_data[24];
			end
		end
	end
endmodule
