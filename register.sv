module register #( ///r no syokika?
	parameter REG_NUM = 32
) (
	input logic RegWrite,
	input logic UART_write_enable,
	input logic [4:0] rs,
	input logic [4:0] rt,
	input logic [4:0] rw,
	input logic [31:0] write_data,
	input logic reset,
	output logic [31:0] op1_sub,
	output logic [31:0] op2_sub
);
	logic [31:0] r [REG_NUM-1:0] = '{
			default : 32'h00000000
	};

	always_comb begin
		if (reset) begin
			op1_sub <= 0;
			op2_sub <= 0;
		end
		op1_sub <= r[rs];
		op2_sub <= r[rt];
		if (RegWrite || UART_write_enable) begin
			r[rw] <= write_data;
		end
	end
endmodule
