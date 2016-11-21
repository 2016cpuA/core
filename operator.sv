module operator(
	input logic [5:0] opcode,
	input logic [5:0] funct,
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
	localparam OP_LW_I = 6'b111110; //デバッグ用命令。
	
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
	assign RegWrite  = buffer[17];		//１ならregidsterにかきこむ
	assign MemtoReg  = buffer[16:15];	//registerに書き込むデータを選択。01:memoryからのデータ。10:aluの計算結果。11:pc(JALの時のリンクレジスタへ)
	assign ALUSrcs   = buffer[14:13];	//op2の選択。00:reg[rt]。01:sa。10:immediate。11:使わない
	assign ALUSrcs2  = buffer[12];		//op1の選択。１ならreg[rs]。０ならreg[rt]
	assign ALUOp 	 = buffer[11:8];	//aluの計算内容を選択。場合分けは面倒。aluを使わないものは1111を設定。
	assign RegDist 	 = buffer[7:6];		//書き込みレジスタを選択。00:rd,01:rt,10:11111（リンクレジスタ）
	assign Branch 	 = buffer[5:4];		//プログラムカウンタ更新先を選択。00:JR 01:J,JAL 10:BEQ,BNE 11:default
	assign MemWrite  = buffer[3];		//１ならメモリに書き込む
	assign MemRead 	 = buffer[2];		//１ならメモリから読む
	assign UARTtoReg = buffer[1];		//１なら入力を受け取る
	assign RegtoUART = buffer[0];		//１なら出力する

	always_comb begin
		case (opcode)
			OP_SP : begin
						case (funct)
							FUNCT_SLL : buffer <= 18'b1_10_01_0_0000_00_11_0_0_0_0;
							FUNCT_SRL : buffer <= 18'b1_10_01_0_0001_00_11_0_0_0_0;
							FUNCT_SRA : buffer <= 18'b1_10_01_0_0010_00_11_0_0_0_0;
							FUNCT_JR :  buffer <= 18'b0_10_00_1_0011_11_00_0_0_0_0;
							FUNCT_ADD : buffer <= 18'b1_10_00_1_0011_00_11_0_0_0_0;
							FUNCT_SUB : buffer <= 18'b1_10_00_1_0100_00_11_0_0_0_0;
							FUNCT_AND : buffer <= 18'b1_10_00_1_0101_00_11_0_0_0_0;
							FUNCT_OR :  buffer <= 18'b1_10_00_1_0110_00_11_0_0_0_0;
							FUNCT_XOR : buffer <= 18'b1_10_00_1_0111_00_11_0_0_0_0;
							FUNCT_SLT : buffer <= 18'b1_10_00_1_1000_00_11_0_0_0_0;
						endcase
					end
			OP_JP :    buffer <= 18'b0_10_11_1_1111_11_01_0_0_0_0;
			OP_JAL :   buffer <= 18'b1_11_11_1_1111_10_01_0_0_0_0;
			OP_BEQ :   buffer <= 18'b0_10_00_1_1001_00_10_0_0_0_0;
			OP_BNE :   buffer <= 18'b0_10_00_1_1010_00_10_0_0_0_0;
			OP_ADDI :  buffer <= 18'b1_10_10_1_0011_01_11_0_0_0_0;
			OP_ANDI :  buffer <= 18'b1_10_10_1_0101_01_11_0_0_0_0;
			OP_ORI :   buffer <= 18'b1_10_10_1_0110_01_11_0_0_0_0;
			OP_LW :    buffer <= 18'b1_01_10_1_0011_01_11_0_1_0_0;
			OP_SW :    buffer <= 18'b0_10_10_1_0011_11_11_1_0_0_0;
			OP_IN :    buffer <= 18'b0_00_11_1_1111_00_11_0_0_1_0;
			OP_OUT :   buffer <= 18'b0_00_11_1_1111_11_11_0_0_0_1;
		endcase
	end
endmodule
