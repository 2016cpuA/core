module write_buffer_pc_generate_test #(
	parameter INST_MEM_WIDTH = 2
)
	logic reset;
	logic RegWrite;
	logic MemtoReg;
	logic Brabch;
	logic UARTtoReg;
	logic [31:0] read_data;
	logic [31:0] register_data;
	logic [31:0] alu_result;
	logic [4:0] rd;
	logic [25:0] inst_index;
	logic [INST_MEM_WIDTH-1:0] pc;
	logic [INST_MEM_WIDTH-1:0] pc1;
	logic [INST_MEM_WIDTH-1:0] pc2;
	logic input_ready;
	logic [31:0] input_data;
	logic RegWrite_next;
	logic UART_write_enable;
	logic [31:0] data;
	logic [4:0] rd_next;
	logic [INST_MEM_WIDTH-1:0] pc_generated;
	logic [INST_MEM_WIDTH-1:0] pc1_next;
	
	localparam WAIT = 5000;
	write_buffer_pc_generate #(INST_MEM_WIDTH) write_buffer_pc_generate_instance(
			reset,
			RegWrite,
			MemtoReg,
			Brabch,
			UARTtoReg,
			read_data,
			register_data,
			alu_result,
			rd,
			inst_index,
			pc,
			pc1,
			pc2,
			input_ready,
			input_data,
			RegWrite_next,
			UART_write_enable,
			data,
			rd_next,
			pc_generated,
			pc1_next
	);

	initial begin
		#WAIT;
		reset <= 1;
		#WAIT;
		reset <= 0;
		//register_write_test
		MemtoReg <= 2'b01;
		UARTtoReg <= 0;
		read_data <= 32'hffffffff;
		alu_result <= 32'h11111111;
		pc <= INST_MEM_WIDTH'b10;
		input_data <= 32'h55555555;
		input_ready <= 0;
		#WAIT;
		MemtoReg <= 2'b10;
		#WAIT;
		MemtoReg <= 2'b11;
		#WAIT;
		UARTtoReg <= 1;
		#WAIT;
		UARTtoReg <= 0;
		#WAIT;
		//branch_test
		Branch <= 2'b00;
		#WAIT;
		Branch <= 2'b10;
		#WAIT;
		//あとは自然に
	end
endmodule
