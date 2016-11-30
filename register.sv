module register (
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
	logic [31:0] r [31:0];// = '{
//			default : 32'h00000000
//	};
	logic buffer;
    integer i;
    
	always_ff @(posedge CLK) begin
		if (reset) begin
			op1_sub <= 0;
			op2_sub <= 0;
			buffer <= 1;
			for (i = 0; i < 32; i = i + 1) begin
				r[i] <= 0;
			end
		end else begin
			op1_sub <= r[rs];
			op2_sub <= r[rt];
			if ((RegWrite || UART_write_enable) && (distinct != buffer)) begin
				r[rw] <= write_data;
				buffer <= distinct;
			end
		end
	end
endmodule
