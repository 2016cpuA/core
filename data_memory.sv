module data_memory #(
	parameter DATA_MEM_WIDTH = 3
) (
	input logic CLK,
	input logic reset,
	input logic [31:0] address,
	input logic [31:0] write_data,
	input logic MemWrite,
	output logic [31:0] read_data,
	input logic MemRead
);
	logic [31:0] data_mem [2**DATA_MEM_WIDTH-1:0];

	always_ff @(posedge CLK) begin
		if (reset) begin
			read_data <= 0;
			for (int i = 0;i < 2**DATA_MEM_WIDTH;i = i + 1) begin
					data_mem[i] <= 32'h00000000;
			end
		end
		else begin
			if (MemWrite) begin
				data_mem[address[DATA_MEM_WIDTH-1:0]] <= write_data;
			end
			if (MemRead) begin
				read_data <= data_mem[address[DATA_MEM_WIDTH-1:0]];
			end
		end
	end
endmodule

