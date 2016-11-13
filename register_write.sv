module register_write(
	input logic [1:0] MemtoReg,
	input logic UARTtoReg,
	input logic reset,
	input logic [31:0] read_data,
	input logic [31:0] alu_result,
	input logic [31:0] pc,
	input logic [31:0] input_data,
	input logic input_ready,
	output logic UART_write_enable,
	output logic pc_enable,
	output logic [31:0] data
);
	logic UARTtoReg_buf;

	always_comb begin
		if (reset) begin
			UARTtoReg_buf <= 0;
			UART_write_enable <= 0;
			pc_enable <= 0;
		end
		case (MemtoReg)
			2'b01 : if (!UARTtoReg) data <= read_data;
			2'b10 : if (!UARTtoReg) data <= alu_result;
			2'b11 : if (!UARTtoReg) data <= pc;
			default : ;
		endcase
		if (UARTtoReg) begin
			UARTtoReg_buf <= UARTtoReg;
			if (input_ready) begin
				data <= input_data;
				UART_write_enable <= 1;
				UARTtoReg_buf <= 0;
				pc_enable <= 1;
			end else begin
				UART_write_enable <= 0;
				pc_enable <= 0;
			end
		end else if (UARTtoReg_buf) begin
			if (input_ready) begin
				data <= input_data;
				UART_write_enable <= 1;
				UARTtoReg_buf <= 0;
				pc_enable <= 1;
			end else begin
				UART_write_enable <= 0;
				pc_enable <= 0;
			end
		end else begin
			UART_write_enable <= 0;
			pc_enable <= 1;
		end
	end
endmodule