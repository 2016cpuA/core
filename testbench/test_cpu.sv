`timescale 1ns/10ps

module test_top #(
	parameter INST_MEM_WIDTH = 5,
	parameter DATA_MEM_WIDTH = 10
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
	localparam WAIT = 2603;
	localparam CLK_ = 1;
	always begin
		CLK <= 1;
		#0.5;
		CLK <= 0;
		#0.5;
	end

	integer fp,status;
	logic buffer;
	initial begin
		#1;
		UART_RX <= 1;
		sw_n_10 <= 0;
		sw_s_8 <= 0;
		#WAIT;
		sw_c_7 <= 1;
		#WAIT;
		sw_c_7 <= 0;
		#WAIT;
		sw_n_10 <= 1;
		#WAIT;
		sw_n_10 <= 0;
		#WAIT;
		#WAIT;
		#WAIT;
		#WAIT;
		fp = $fopen("/home/tansei/Documents/3a/cpuEX/cpuEX/srcs/testbench/bin__", "r");
		if (fp!=0)begin
			while(!$feof(fp))begin
				status = $fscanf(fp, "%1b\n", buffer);
				$display(buffer);
				UART_RX <= buffer;
				#WAIT;
			end
		end
		sw_s_8 <= 1;
		#WAIT;
		sw_s_8 <= 0;
	end	
endmodule
