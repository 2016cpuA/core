module test_top #(
	parameter INST_MEM_WIDTH = 2,
	parameter DATA_MEM_WIDTH = 3
);
    logic CLK;
	logic UART_RX;
	logic sw_n_10;
	logic sw_c_7;
//	logic sw_e_9;
	logic sw_s_8;
//	logic sw_w_6;
//	logic [3:0] sw;
	logic UART_TX;
	logic [3:0] led;

	localparam WAIT = 5000;
	localparam CLK_ = 1;
	always begin
		CLK <= 1;
		#0.5;
		CLK <= 0;
		#0.5;
	end

	initial begin
		UART_RX <= 1;
		sw_n_10 <= 0;
		sw_s_8 <= 0;
		#WAIT;
		sw_c_7 <= 1;
		#WAIT;
		sw_c_7 <= 0;
	end	
	//reset
	logic reset;
	assign reset = sw_c_7;

	//receiver and sender
	logic [7:0] receiver_data;
	logic [7:0] sender_data;
	logic receiver_valid;
	logic sender_enable;
	logic sender_ready;

	//receiver buffer
	logic [31:0] input_data;
	logic input_ready;

	//sender_buffer
	logic sender_valid;
	logic sender_buffer_enable;

	//inst_fetch
	logic [INST_MEM_WIDTH-1:0] pc_to_if;
	logic [INST_MEM_WIDTH-1:0] pc1_to_if;
	logic [7:0] input_data_to_if;
	logic input_start_to_if;
	logic input_end_to_if;
	logic input_valid_to_if;
	logic [31:0] inst_from_if;
	logic inst_enable_from_if;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_if;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_if;

	//inst_decode
	logic [31:0] inst_to_id;
	logic [INST_MEM_WIDTH-1:0] pc_to_id;
	logic [INST_MEM_WIDTH-1:0] pc1_to_id;
	logic RegWrite_before_to_id;
	logic UART_write_enable_to_id;
	logic [31:0] data_to_id;
	logic [4:0] address_to_id;
 	logic RegWrite_from_id;
	logic [1:0] MemtoReg_from_id;
	logic [1:0] ALUSrcs_from_id;
	logic ALUSrcs2_from_id;
	logic [3:0] ALUOp_from_id;
	logic [1:0] RegDist_from_id;
	logic [1:0] Branch_from_id;
	logic MemWrite_from_id;
	logic MemRead_from_id;
	logic UARTtoReg_from_id;
	logic RegtoUART_from_id;
	logic [31:0] op1_from_id;
	logic [31:0] op2_from_id;
	logic [4:0] rt_from_id;
	logic [4:0] rd_from_id;
	logic [4:0] sa_from_id;
	logic [15:0] immediate_from_id;
	logic [25:0] inst_index_from_id;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_id;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_id;

	//execution
	logic RegWrite_to_ex;
	logic [1:0] MemtoReg_to_ex;
	logic [1:0] ALUSrcs_to_ex;
	logic ALUSrcs2_to_ex;
	logic [3:0] ALUOp_to_ex;
	logic [1:0] RegDist_to_ex;
	logic [1:0] Branch_to_ex;
	logic MemWrite_to_ex;
	logic MemRead_to_ex;
	logic UARTtoReg_to_ex;
	logic RegtoUART_to_ex;
	logic [31:0] op1_sub_to_ex;
	logic [31:0] op2_sub_to_ex;
	logic [4:0] rt_to_ex;
	logic [4:0] rd_to_ex;
	logic [4:0] sa_to_ex;
	logic [15:0] immediate_to_ex;
	logic [25:0] inst_index_to_ex;
	logic [INST_MEM_WIDTH-1:0] pc_to_ex;
	logic [INST_MEM_WIDTH-1:0] pc1_to_ex;
 	logic RegWrite_next_from_ex;
	logic [1:0] MemtoReg_next_from_ex;
	logic [1:0] Branch_next_from_ex;
	logic MemWrite_next_from_ex;
	logic MemRead_next_from_ex;
	logic UARTtoReg_next_from_ex;
	logic [31:0] register_data_from_ex;
	logic [31:0] alu_result_from_ex;
	logic [4:0] rdist_from_ex;
	logic [25:0] inst_index_next_from_ex;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_ex;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_ex;
	logic [INST_MEM_WIDTH-1:0] pc2_from_ex;

	//memory_access
 	logic RegWrite_to_mem;
	logic [1:0] MemtoReg_to_mem;
	logic [1:0] Branch_to_mem;
	logic MemWrite_to_mem;
	logic MemRead_to_mem;
	logic UARTtoReg_to_mem;
	logic [31:0] register_data_to_mem;
	logic [31:0] alu_result_to_mem;
	logic [4:0] rdist_to_mem;
	logic [25:0] inst_index_to_mem;
	logic [INST_MEM_WIDTH-1:0] pc_to_mem;
	logic [INST_MEM_WIDTH-1:0] pc1_to_mem;
	logic [INST_MEM_WIDTH-1:0] pc2_to_mem;
 	logic RegWrite_next_from_mem;
	logic [1:0] MemtoReg_next_from_mem;
	logic [1:0] Branch_next_from_mem;
	logic UARTtoReg_next_from_mem;
	logic [31:0] read_data_from_mem;
	logic [31:0] register_data_next_from_mem;
	logic [31:0] alu_result_next_from_mem;
	logic [4:0] rdist_next_from_mem;
	logic [25:0] inst_index_next_from_mem;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_mem;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_mem;
	logic [INST_MEM_WIDTH-1:0] pc2_next_from_mem;


	//wriet_buffer_pc_generate
	logic RegWrite_to_wb;
	logic [1:0] MemtoReg_to_wb;
	logic [1:0] Branch_to_wb;
	logic UARTtoReg_to_wb;
	logic [31:0] read_data_to_wb;
	logic [31:0] register_data_to_wb;
	logic [31:0] alu_result_to_wb;
	logic [4:0] rd_to_wb;
	logic [25:0] inst_index_to_wb;
	logic [INST_MEM_WIDTH-1:0] pc_to_wb;
	logic [INST_MEM_WIDTH-1:0] pc1_to_wb;
	logic [INST_MEM_WIDTH-1:0] pc2_to_wb;
	logic input_ready_to_wb;
	logic [31:0] input_data_to_wb;
	logic RegWrite_next_from_wb;
	logic UART_write_enable_from_wb;
	logic [31:0] data_from_wb;
	logic [4:0] rd_next_from_wb;
	logic [INST_MEM_WIDTH-1:0] pc_generated_from_wb;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_wb;

	//sender ans receiver
	assign sender_buffer_enable = sender_valid | RegtoUART_to_ex;
	
	receiver receiver_instance (
			CLK, 
			UART_RX, 
			receiver_data, 
			receiver_valid
	);
	sender sender_instance (
			CLK, 
			sender_data, 
			sender_enable, 
			UART_TX, 
			sender_ready
	);
	receiver_buffer reveiver_buffer_instance (
			CLK, 
			receiver_data, 
			receiver_valid, 
			input_data, 
			input_ready
	);
	sender_buffer sender_buffer_instance (
			CLK, 
			reset, 
			op1_sub_to_ex, 
			sender_buffer_enable, 
			sender_ready, 
			sender_data, 
			sender_enable, 
			sender_valid
	);

	//inst fetch
	inst_fetch #(INST_MEM_WIDTH) inst_fetch_instance(
			CLK, 
			reset, 
			pc_to_if, 
			pc1_to_if, 
			input_data_to_if, 
			input_start_to_if, 
			input_end_to_if, 
			input_valid_to_if,
			inst_from_if, 
			inst_enable_from_if, 
			pc_next_from_if, 
			pc1_next_from_if
	);
	
	//inst decode
	inst_decode #(INST_MEM_WIDTH) inst_decode_instance(
			reset, 
			inst_to_id, 
			pc_to_id, 
			pc1_to_id, 
			RegWrite_before_to_id, 
			UART_write_enable_to_id, 
			data_to_id, 
			address_to_id, 
			RegWrite_from_id, 
			MemtoReg_from_id, 
			ALUSrcs_from_id, 
			ALUSrcs2_from_id, 
			ALUOp_from_id, 
			RegDist_from_id, 
			Branch_from_id, 
			MemWrite_from_id, 
			MemRead_from_id, 
			UARTtoReg_from_id, 
			RegtoUART_from_id, 
			op1_from_id, 
			op2_from_id, 
			rt_from_id, 
			rd_from_id, 
			sa_from_id, 
			immediate_from_id, 
			inst_index_from_id, 
			pc_next_from_id, 
			pc1_next_from_id
	);

	//execution
	execution #(INST_MEM_WIDTH) execution_instance(
			RegWrite_to_ex, 
			MemtoReg_to_ex, 
			ALUSrcs_to_ex, 
			ALUSrcs2_to_ex, 
			ALUOp_to_ex, 
			RegDist_to_ex, 
			Branch_to_ex, 
			MemWrite_to_ex, 
			MemRead_to_ex, 
			UARTtoReg_to_ex, 
			RegtoUART_to_ex, 
			op1_sub_to_ex, 
			op2_sub_to_ex, 
			rt_to_ex, 
			rd_to_ex, 
			sa_to_ex, 
			immediate_to_ex, 
			inst_index_to_ex, 
			pc_to_ex, 
			pc1_to_ex, 
			RegWrite_next_from_ex, 
			MemtoReg_next_from_ex, 
			Branch_next_from_ex, 
			MemWrite_next_from_ex, 
			MemRead_next_from_ex, 
			UARTtoReg_next_from_ex, 
			register_data_from_ex, 
			alu_result_from_ex, 
			rdist_from_ex, 
			inst_index_next_from_ex, 
			pc_next_from_ex, 
			pc1_next_from_ex, 
			pc2_from_ex
	);

	//memory access
	memory_access #(INST_MEM_WIDTH, DATA_MEM_WIDTH) memory_access_instance(
			CLK, 
			reset, 
			RegWrite_to_mem, 
			MemtoReg_to_mem, 
			Branch_to_mem, 
			MemWrite_to_mem, 
			MemRead_to_mem, 
			UARTtoReg_to_mem, 
			register_data_to_mem, 
			alu_result_to_mem, 
			rdist_to_mem, 
			inst_index_to_mem, 
			pc_to_mem, 
			pc1_to_mem, 
			pc2_to_mem, 
			RegWrite_next_from_mem, 
			MemtoReg_next_from_mem, 
			Branch_next_from_mem, 
			UARTtoReg_next_from_mem, 
			read_data_from_mem, 
			register_data_next_from_mem, 
			alu_result_next_from_mem, 
			rdist_next_from_mem, 
			inst_index_next_from_mem, 
			pc_next_from_mem, 
			pc1_next_from_mem, 
			pc2_next_from_mem
	);

	//write buffer pc generate
	write_buffer_pc_generate #(INST_MEM_WIDTH) write_buffer_pc_generator_instancc(
			reset, 
			RegWrite_to_wb, 
			MemtoReg_to_wb, 
			Branch_to_wb, 
			UARTtoReg_to_wb, 
			read_data_to_wb, 
			register_data_to_wb, 
			alu_result_to_wb, 
			rd_to_wb, 
			inst_index_to_wb, 
			pc_to_wb, 
			pc1_to_wb, 
			pc2_to_wb, 
			input_ready_to_wb, 
			input_data_to_wb, 
			RegWrite_next_from_wb, 
			UART_write_enable_from_wb, 
			data_from_wb, 
			rd_next_from_wb, 
			pc_generated_from_wb, 
			pc1_next_from_wb
	);

	assign pc_to_if 			= pc_generated_from_wb;
	assign pc1_to_if 			= pc1_next_from_wb;
	assign input_data_to_if 	= receiver_data;
	assign input_start_to_if 	= sw_n_10;
	assign input_end_to_if 		= sw_s_8;
	assign input_valid_to_if 	= receiver_valid;
	assign RegWrite_to_mem 		= RegWrite_next_from_ex;
	assign MemtoReg_to_mem 		= MemtoReg_next_from_ex;
	assign Branch_to_mem 		= Branch_next_from_ex;
	assign MemWrite_to_mem 		= MemWrite_next_from_ex;
	assign MemRead_to_mem 		= MemRead_next_from_ex;
	assign UARTtoReg_to_mem 	= UARTtoReg_next_from_ex;
	assign register_data_to_mem = register_data_from_ex;
	assign alu_result_to_mem 	= alu_result_from_ex;
	assign rdist_to_mem 		= rdist_from_ex;
	assign inst_index_to_mem 	= inst_index_next_from_ex;
	assign pc_to_mem 			= pc_next_from_ex;
	assign pc1_to_mem 			= pc1_next_from_ex;
	assign pc2_to_mem 			= pc2_from_ex;
	assign RegWrite_to_wb 		= RegWrite_next_from_mem;
	assign MemtoReg_to_wb 		= MemtoReg_next_from_mem;
	assign Branch_to_wb 		= Branch_next_from_mem;
	assign UARTtoReg_to_wb 		= UARTtoReg_next_from_mem;
	assign read_data_to_wb 		= read_data_from_mem;
	assign register_data_to_wb 	= register_data_next_from_mem;
	assign alu_result_to_wb 	= alu_result_next_from_mem;
	assign rd_to_wb 			= rdist_next_from_mem;
	assign inst_index_to_wb 	= inst_index_next_from_mem;
	assign pc_to_wb 			= pc_next_from_mem;
	assign pc1_to_wb 			= pc1_next_from_mem;
	assign pc2_to_wb 			= pc2_next_from_mem;
	assign input_ready_to_wb 	= input_ready;
	assign input_data_to_wb 	= input_data;

	always_ff @(posedge CLK) begin
		if (reset) begin
			led <= 0;
		end

	//inst_decode
	if (inst_enable_from_if) begin
		inst_to_id <= inst_from_if;
		pc_to_id <= pc_next_from_if;
		pc1_to_id <= pc1_next_from_if;
	end
	RegWrite_before_to_id <= RegWrite_next_from_wb;
	UART_write_enable_to_id <= UART_write_enable_from_wb;
	data_to_id <= data_from_wb;
	address_to_id <= rd_next_from_wb;

	//execution
	RegWrite_to_ex <= RegWrite_from_id;
	MemtoReg_to_ex <= MemtoReg_from_id;
	ALUSrcs_to_ex <= ALUSrcs_from_id;
	ALUSrcs2_to_ex <= ALUSrcs2_from_id;
   	ALUOp_to_ex <= ALUOp_from_id;
	RegDist_to_ex <= RegDist_from_id;
	Branch_to_ex <= Branch_from_id;
	MemWrite_to_ex <= MemWrite_from_id;
	MemRead_to_ex <= MemRead_from_id;
	UARTtoReg_to_ex <= UARTtoReg_from_id;
	RegtoUART_to_ex <= RegtoUART_from_id;
	op1_sub_to_ex <= op1_from_id;
	op2_sub_to_ex <= op2_from_id;
	rt_to_ex <= rt_from_id; 
	rd_to_ex <= rd_from_id;
	sa_to_ex <= sa_from_id;
	immediate_to_ex <= immediate_from_id;
	inst_index_to_ex <= inst_index_from_id;
	pc_to_ex <= pc_next_from_id;
	pc1_to_ex <= pc1_next_from_id;

	//inst_fetch
	end
endmodule
