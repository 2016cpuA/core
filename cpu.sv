module top #(  // todo : reset system
	parameter INST_MEM_WIDTH = 2,
	parameter DATA_MEM_WIDTH = 3
) (
	input logic CLK_P,
	input logic CLK_N,
	input logic UART_RX,
	input logic sw_n_10,
	input logic sw_c_7,
//	input logic sw_e_9,
	input logic sw_s_8,
//	input logic sw_w_6,
//	input logic [3:0] sw,
	output logic UART_TX,
	output logic [3:0] led
);
	//clk generate
	logic CLK;
	IBUFGDS IBUBFGDS_instance(.I(CLK_P), .IB(CLK_N), .O(CLK));
	
	top_sub #(INST_MEM_WIDTH, DATA_MEM_WIDTH) top_sub_instance(
			CLK,
			UART_RX,
			sw_n_10,
			sw_c_7,
//			sw_e_9,
			sw_s_8,
//			sw_w_6,
//			sw,
			UART_TX,
			led
	);
endmodule
