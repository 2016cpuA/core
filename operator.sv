module operator(
	input logic [5:0] opcode,
	input logic [5:0] funct,
	input logic reset,
	output logic RegWrite,
	output logic [1:0] MemtoReg,
	output logic [1:0] ALUSrcs,
	output logic ALUSrcs2,
	output logic [3:0] ALUOp,
	output logic [1:0] RegDist,
	output logic [1:0] Branch,
	output logic MemWrite,
	output logic MemRead,
	output logic UARTtoReg,
	output logic RegtoUART
);
	
	localparam OP_SP   = 6'b000000;
	localparam OP_JP   = 6'b000010;
	localparam OP_JAL  = 6'b000011;
	localparam OP_BEQ  = 6'b000100;
	localparam OP_BNE  = 6'b000101;
	localparam OP_ADDI = 6'b001000;
	localparam OP_ANDI = 6'b001100;
	localparam OP_ORI  = 6'b001101;
	localparam OP_LW   = 6'b100011;
	localparam OP_SW   = 6'b101011;
	localparam OP_IN   = 6'b111011;
	localparam OP_OUT  = 6'b111100;
	localparam OP_LW_I = 6'b111110; 
	
	localparam FUNCT_SLL = 6'b000000;
	localparam FUNCT_SRL = 6'b000010;
	localparam FUNCT_SRA = 6'b000011;
	localparam FUNCT_JR  = 6'b001000;
	localparam FUNCT_ADD = 6'b100000;
	localparam FUNCT_SUB = 6'b100010;
	localparam FUNCT_AND = 6'b100100;
	localparam FUNCT_OR  = 6'b100101;
	localparam FUNCT_XOR = 6'b100110;
	localparam FUNCT_SLT = 6'b101010;

	logic [17:0] buffer;
	assign RegWrite  = buffer[0];
	assign MemtoReg  = buffer[2:1];
	assign ALUSrcs   = buffer[4:3];
	assign ALUSrcs2  = buffer[5];
	assign ALUOp 	 = buffer[9:6];
	assign RegDist 	 = buffer[11:10];
	assign Branch 	 = buffer[13:12];
	assign MemWrite  = buffer[14];
	assign MemRead 	 = buffer[15];
	assign UARTtoReg = buffer[16];
	assign RegtoUART = buffer[17];

	always_comb begin
		if (reset) begin
			buffer <= 0;	
		end
		case (opcpde)
			OP_SP : begin
						case (funct)
							FUNCT_SLL : buffer <= 17'b1_10_01_0_0000_00_11_0_0_0_0;
							FUNCT_SRL : buffer <= 17'b1_10_01_0_0001_00_11_0_0_0_0;
							FUNCT_SRA : buffer <= 17'b1_10_01_0_0010_00_11_0_0_0_0;
							FUNCT_JR :  buffer <= 17'b0_10_00_1_0011_11_00_0_0_0_0;
							FUNCT_ADD : buffer <= 17'b1_10_00_1_0011_00_11_0_0_0_0;
							FUNCT_SUB : buffer <= 17'b1_10_00_1_0100_00_11_0_0_0_0;
							FUNCT_AND : buffer <= 17'b1_10_00_1_0101_00_11_0_0_0_0;
							FUNCT_OR :  buffer <= 17'b1_10_00_1_0110_00_11_0_0_0_0;
							FUNCT_XOR : buffer <= 17'b1_10_00_1_0111_00_11_0_0_0_0;
							FUNCT_SLT : buffer <= 17'b1_10_00_1_1000_00_11_0_0_0_0;
						endcase
					end
			OP_JP :    buffer <= 17'b0_10_11_1_1111_11_01_0_0_0_0;
			OP_JAL :   buffer <= 17'b1_11_11_1_1111_10_01_0_0_0_0;
			OP_BEQ :   buffer <= 17'b0_10_00_1_1001_00_10_0_0_0_0;
			OP_BNE :   buffer <= 17'b0_10_00_1_1010_00_10_0_0_0_0;
			OP_ADDI :  buffer <= 17'b1_10_10_1_0011_01_11_0_0_0_0;
			OP_ANDI :  buffer <= 17'b1_10_10_1_0101_01_11_0_0_0_0;
			OP_ORI :   buffer <= 17'b1_10_10_1_0110_01_11_0_0_0_0;
			OP_LW :    buffer <= 17'b1_01_10_1_0011_01_11_0_1_0_0;
			OP_SW :    buffer <= 17'b0_10_10_1_0011_11_11_1_0_0_0;
			OP_IN :    buffer <= 17'b0_10_11_1_1111_00_11_0_0_1_0;
			OP_OUT :   buffer <= 17'b0_10_11_1_1111_11_11_0_0_0_1;
		endcase
	end
endmodule
