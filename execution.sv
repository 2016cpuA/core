module execution #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic AorF,
 	input logic RegWrite,
	input logic [1:0] MemtoReg,
	input logic [1:0] ALUSrcs,
	input logic ALUSrcs2,
	input logic [3:0] ALUOp,
	input logic [1:0] RegDist,
	input logic [1:0] Branch,
	input logic MemWrite,
	input logic MemRead,
	input logic UARTtoReg,
	input logic RegtoUART,
	input logic [31:0] op1_sub,
	input logic [31:0] op2_sub,
	input logic [4:0] rt,
	input logic [4:0] rd,
	input logic [4:0] sa,
	input logic [15:0] immediate,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	output logic distinct_next,
	output logic AorF_next,
 	output logic RegWrite_next,
	output logic [1:0] MemtoReg_next,
	output logic [1:0] Branch_next,
	output logic MemWrite_next,
	output logic MemRead_next,
	output logic UARTtoReg_next,
	output logic [31:0] register_data,
	output logic [31:0] result,
	output logic valid,
	output logic [4:0] rdist,
	output logic [25:0] inst_index_next,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next,
	output logic [INST_MEM_WIDTH-1:0] pc2
);
	logic [31:0] op1;
	logic [31:0] op2;
	logic AorF_;
	logic [1:0] ALUSrcs_;
	logic ALUSrcs2_;
	logic [3:0] ALUOp_;
	logic [1:0] RegDist_;
	logic [31:0] op1_sub_;
	logic [31:0] op2_sub_;
	logic [4:0] rt_;
	logic [4:0] rd_;
	logic [4:0] sa_;
	logic [15:0] immediate_;
	logic [INST_MEM_WIDTH-1:0] pc_;
	logic [31:0] alu_result;
	logic [31:0] fpu_result;
	logic fpu_valid;
	logic state;

	op1_sel op1_sel_instance(
			ALUSrcs2_, 
			op1_sub_, 
			op2_sub_, 
			op1
	);
	op2_sel op2_sel_instance(
			ALUSrcs_, 
			op2_sub_, 
			sa_, 
			immediate_, 
			op2
	);
	dist_sel dist_sel_instance(
			RegDist_, 
			rd_, 
			rt_, 
			rdist
	);
	pc_adder #(INST_MEM_WIDTH) pc_adder2_instance(
			pc_, 
			immediate_[INST_MEM_WIDTH-1:0], 
			pc2
	);
	alu alu_instance(
			ALUOp_, 
			op1, 
			op2, 
			alu_result
	);
	fpu fpu_instance(
			CLK,
			reset,
			AorF_,
			ALUOp_,
			op1,
			op2,
			fpu_result,
			fpu_valid
	);

	always_ff @(posedge CLK) begin
		if (reset) begin
		distinct_next <= 0;
		AorF_next <= 0;
		RegWrite_next <= 0;
		MemtoReg_next <= 0;
		Branch_next <= 2'b11;
		MemWrite_next <= 0;
		MemRead_next <= 0;
		UARTtoReg_next <= 0;
		register_data <= 0;
		inst_index_next <= 0;
		pc_next <= 0;
		pc1_next <= 0;
		AorF_ <= 0;
		ALUSrcs_ <= 0;
		ALUSrcs2_ <= 0;
		ALUOp_ <= 0;
		RegDist_ <= 0;
		op1_sub_ <= 0;
		op2_sub_ <= 0;
		rt_ <= 0;
		rd_ <= 0;
		sa_ <= 0;
		immediate_ <= 0;
		pc_ <= 0;
		state <= 0;
		result <= 0;
		valid <= 0;
		end else begin
		if (! AorF && state ==  0) begin
		distinct_next <= distinct;
		AorF_next <= AorF;
		RegWrite_next <= RegWrite;
		MemtoReg_next <= MemtoReg;
		Branch_next <= Branch;
		MemWrite_next <= MemWrite;
		MemRead_next <= MemRead;
		UARTtoReg_next <= UARTtoReg;
		register_data <= op2_sub;
		inst_index_next <= inst_index;
		pc_next <= pc;
		pc1_next <= pc1;
		AorF_ <= AorF;
		ALUSrcs_ <= ALUSrcs;
		ALUSrcs2_ <= ALUSrcs2;
		ALUOp_ <= ALUOp;
		RegDist_ <= RegDist;
		op1_sub_ <= op1_sub;
		op2_sub_ <= op2_sub;
		rt_ <= rt;
		rd_ <= rd;
		sa_ <= sa;
		immediate_ <= immediate;
		pc_ <= pc;
		result <= alu_result;
		valid <= 1;
		end else if (state == 0) begin
			if (MemWrite || MemRead) begin	
				AorF_ <= 0;
			end else begin
				AorF_ <= 1;
			end
			ALUSrcs_ <= ALUSrcs;
			ALUSrcs2_ <= ALUSrcs2;
			ALUOp_ <= ALUOp;
			RegDist_ <= RegDist;
			op1_sub_ <= op1_sub;
			op2_sub_ <= op2_sub;
			rt_ <= rt;
			rd_ <= rd;
			sa_ <= sa;
			immediate_ <= immediate;
			pc_ <= pc;	
			state <= state + 1;
			valid <= 0;
		end else if (state == 1 && fpu_valid) begin
			distinct_next <= distinct;
			AorF_next <= AorF;
			RegWrite_next <= RegWrite;
			MemtoReg_next <= MemtoReg;
			Branch_next <= Branch;
			MemWrite_next <= MemWrite;
			MemRead_next <= MemRead;
			UARTtoReg_next <= UARTtoReg;
			register_data <= op2_sub;
			inst_index_next <= inst_index;
			pc_next <= pc;
			pc1_next <= pc1;
			result <= fpu_result;
			valid <= 1;
			state <= 0;
		end
		end
	end
endmodule
		
