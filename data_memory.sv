module data_memory #(
	parameter DATA_MEM_WIDTH = 3
) (
	input logic CLK,
	input logic [31:0] write_data,
	input logic write_enable,
	output logic write_ready,
	input logic write_index,
	output logic [31:0] read_data,
	input logic read_enable,
	input logic read_index
);
	logic [31:0] data_mem [2**DATA_MEM_WIDTH];
	integer state = 0;
	always @(posedge CLK) begin
		if (state == 0) begin
			if (write_enable) begin
				state <= 1;
			end else if (read_enable) begin
				state <= 2;
			end
		end else if (state == 1) begin
			write_ready <= 1;
			data_mem[write_index] <= write_data;
			state <= 0;
		end else if (state == 2) begin
			read_data <= data_mem[read_index];
			state <= 0;
		end	
	end
endmodule

