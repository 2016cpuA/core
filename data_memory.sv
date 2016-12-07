module data_memory #(
	parameter DATA_MEM_WIDTH = 3
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic [31:0] address,
	input logic [31:0] write_data,
	input logic MemWrite,
	output logic [31:0] read_data,
	input logic MemRead
);
	logic [31:0] data_mem [2**DATA_MEM_WIDTH-1:0];
	logic [31:0] addr_buf;
	logic [1:0] state;
	always_ff @(posedge CLK) begin
		if (reset) begin
			read_data <= 0;
			state <= 0;
			addr_buf <= 0;
			for (int i = 0;i < 2**DATA_MEM_WIDTH;i = i + 1) begin
					data_mem[i] <= 32'h00000000;
			end
		end
		else begin
			if (state == 0 && MemWrite && distinct) begin
				addr_buf <= address;
				state <= 1;
			end else if (state == 0 && MemRead && distinct) begin
				addr_buf <= address;
				state <= 2;
			end else if (state == 1) begin
				data_mem[addr_buf[DATA_MEM_WIDTH-1:0]] <= write_data;
				state <= 0;
			end else if (state == 2) begin
				read_data <= data_mem[addr_buf[DATA_MEM_WIDTH-1:0]];
				state <= 0;
			end else begin
				state <= 0;
			end
		end
	end
endmodule

