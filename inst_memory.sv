module inst_memory #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [7:0] loader_data,
	input logic loader_enable,
	output logic [31:0] inst,
	input logic loader_ready
);
	logic [31:0] inst_mem [2**INST_MEM_WIDTH-1:0] = '{
		0 : 32'hec000000,
		1 : 32'hf0000000,
		2 : 32'h20000001,
		3 : 32'hf0000000
	};
	logic [31:0] loader_buf;
	logic [INST_MEM_WIDTH-1:0] loader_index = 0;
	integer state = 0;
	logic [7:0] order_change;
	
//	assign order_change[0] = loader_data[7];
//	assign order_change[1] = loader_data[6];
//	assign order_change[2] = loader_data[5];
//	assign order_change[3] = loader_data[4];
//	assign order_change[4] = loader_data[3];
//	assign order_change[5] = loader_data[2];
//	assign order_change[6] = loader_data[1];
//	assign order_change[7] = loader_data[0];

	assign order_change = loader_data;

	always @(posedge CLK) begin
	   	inst = inst_mem[pc];
		if (state == 0) begin
			if (loader_enable) begin
				state <= state + 1;
			end
		end else if (state == 1) begin
			if (loader_ready) begin
				loader_buf[7:0] <= order_change;
				state <= state + 1;
			end
		end else if (state == 2) begin
			if (loader_ready) begin
				loader_buf[15:8] <= order_change;
				state <= state + 1;
			end
		end else if (state == 3) begin
			if (loader_ready) begin
				loader_buf[23:16] <= order_change;
				state <= state + 1;
			end
		end else if (state == 4) begin
			if (loader_ready) begin
				loader_buf[31:24] <= order_change;
				state <= state + 1;
			end
		end else if (state == 5) begin
			inst_mem[loader_index] <= loader_buf;
			if (loader_enable) begin
				state <= 1;
				loader_index <= loader_index + 1;
			end else begin
				state <= 0;
				loader_index <= 0;
			end
		end
	end
endmodule
