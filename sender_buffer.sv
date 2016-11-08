module sender_buffer #(
	parameter BUFFER_SIZE = 32
) (
	input logic CLK,
	input logic reset,
	input logic [31:0] data,
	input logic enable,
	input logic sender_ready,
	output logic [7:0] output_data,
	output logic valid,
	output logic ready
);
	logic [31:0] buffer [BUFFER_SIZE-1:0];
	logic [BUFFER_SIZE-1:0] head;
	logic [BUFFER_SIZE-1:0] tail;
	logic full;
	integer state;
	integer state2;

	always @(posedge CLK) begin
		if (reset) begin
			buffer <= '{default : 0};
			head <= 0;
			tail <= 0;
			full <= 0;
			state <= 0;
			state2 <= 0;
			valid <= 0;
		end
		if (head == tail && full) begin
			ready <= 0;
		end else begin
			ready <= 1;
		end
		if (enable && state == 0) begin
			buffer[tail] <= data;
			tail <= tail + 1;
			state <= state + 1;
		end else if (state == 1) begin
			if (head == tail) begin
				full <= 1;
			end else begin
				full <= 0;
			end
			state <= 0;
		end
		if ((head != tail || !full) && state2 == 0) begin
			output_data <= buffer[head][31:24];
			valid <= 1;
			state2 <= state2 + 1;
		end else if (state2 == 1 && sender_ready) begin
			output_data <= buffer[head][23:16];
			state2 <= state2 + 1;
		end else if (state2 == 2 && sender_ready) begin
			output_data <= buffer[head][15:8];
			state2 <= state2 + 1;
		end else if (state2 == 3 && sender_ready) begin
			output_data <= buffer[head][7:0];
			state2 <= state2 + 1;
		end else if (state2 == 4 && sender_ready) begin
			state2 <= 0;
			valid <= 0;
			head <= head + 1;
		end
	end
endmodule
