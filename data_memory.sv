module data_memory #(
	parameter DATA_MEM_WIDTH = 3
) (
	input logic CLK,
	input logic reset,
	input logic [31:0] addres,
	input logic [31:0] write_data,
	input logic MemWrite,
	output logic [31:0] read_data,
	input logic MemRead
);
	logic [31:0] data_mem [2**DATA_MEM_WIDTH-1:0];
	integer state;
	always @(posedge CLK) begin
		if (reset) begin
			state <= 0;
		end
		if (MemWrite) begin
			data_mem[address[DATA_MEM_WIDTH-1:0] <= write_data;
		end;
		if (MemRead) begin
			read_data <= data_mem[address[DATA_MEM_WIDTH-1:0];
		end
	end
endmodule

