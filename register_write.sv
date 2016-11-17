module register_write #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK,
	input logic reset,
	input logic [1:0] MemtoReg,
	input logic UARTtoReg,
	input logic [31:0] read_data,
	input logic [31:0] alu_result,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [31:0] input_data,
	input logic input_ready,
	output logic UART_write_enable,
	output logic pc_enable,
	output logic [31:0] data
);
	logic UARTtoReg_buf;

	always_ff @(posedge CLK) begin
		if (reset) begin
			UART_write_enable <= 0;
			pc_enable <= 1;
			data <= 0;
			UARTtoReg_buf <= 0;
		end else begin
			case (MemtoReg)
				2'b01 : if (!UARTtoReg) data <= read_data; else data <= 0;
				2'b10 : if (!UARTtoReg) data <= alu_result; else data <= 0;
				2'b11 : if (!UARTtoReg) data <= pc; else data <= 0;//dataとpcの長さが違うが大丈夫か？
				default : data <= 0;
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
	end
endmodule
