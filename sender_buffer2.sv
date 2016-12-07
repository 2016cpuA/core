module sender_buffer2 (
	input logic CLK,
	input logic reset,
	input logic [31:0] data,
	input logic start,
	input logic sender_ready,
	output logic [7:0] output_data,
	output logic valid
);
	logic [31:0] buffer [31:0];
	logic [4:0] tail;
	logic [4:0] head;
	logic start_buffer;
	logic [2:0] state;
	logic buffer_enable;
	integer i;

	always_ff @(posedge CLK) begin
		if (reset) begin
			output_data <= 0;
			valid <= 0;
			for (i = 0; i < 32; i = i + 1) buffer[i] <= 0;
			tail <= 0;
			head <= 0;
			start_buffer <= 0;
			state <= 0;
			buffer_enable <= 0;
		end else begin
			if ((state == 0) && (start != start_buffer) && start) begin
				start_buffer <= start;
				state <= state + 1;
			end else if ((state == 0) && (start != start_buffer) && !start) begin
				start_buffer <= start;
			end else if ((state == 1) && start_buffer) begin
				buffer[tail] <= data;
				tail = tail + 1;
				buffer_enable <= 1;
				state <= state + 1;
			end if ((state == 2) && sender_ready && buffer_enable) begin
				output_data <= buffer[head][31:24];
				state <= state + 1;
				valid <= 1;
			end else if ((state == 3) && sender_ready) begin
				output_data <= buffer[head][23:16];
				state <= state + 1;
			end else if ((state == 4) && sender_ready) begin
				output_data <= buffer[head][15:8];
				state <= state + 1;
			end else if ((state == 5) && sender_ready) begin
				output_data <= buffer[head][7:0];
				state <= state + 1;
			end else if ((state >= 6) && (start != start_buffer) && sender_ready) begin
				state <= 0;
				valid <= 0;
				buffer_enable <= 0;
				head = head + 1;
			end else if ((state >= 6) && (start == start_buffer) && sender_ready) begin
				valid <= 0;
				buffer_enable <= 0;
				head = head + 1;
			end
		end
	end
endmodule

