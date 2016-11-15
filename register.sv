module register #( ///r no syokika?
	parameter REG_NUM = 32
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic RegWrite,
	input logic UART_write_enable,
	input logic [4:0] rs,
	input logic [4:0] rt,
	input logic [4:0] rw,
	input logic [31:0] write_data,
	output logic [31:0] op1_sub,
	output logic [31:0] op2_sub
);
	logic [31:0] r [REG_NUM-1:0] = '{
			2 : 5'b00011,
			default : 32'h00000000
	};
	logic buffer;

	always_ff begin
		if (reset) begin
			op1_sub <= 0;
			op2_sub <= 0;
			buffer <= 0;
			for (i = 0; i < REG__NUM; i = i + 1) begin
				r[i] <= 0;
			end
		end else begin
			op1_sub <= r[rs];
			op2_sub <= r[rt];
			if ((RegWrite || UART_write_enable) && (distinct != buffer) begin
				buffer <= write_data;
				buffer <= distinct;
			end
		end
	end
endmodule
