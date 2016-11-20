module sender_buffer2 (
	input logic CLK,
	input logic reset,
	input logic [31:0] data;
	input logic start;
	input logic sender_ready;
	output logic [7:0] output_data;
	output logic valid;
);
	logic [31:0] buffer;
	logic start_buffer;
	logic [2:0] state;
	logic buffer_enable;

	always_ff @(posedge CLK) begin
		if (reset) begin
			output_data <= 0;
			valid <= 0;
			buffer <= 0;
			start_buffer <= 0;
			state <= 0;
			buffer_enable <= 0;
		end else begin
			if (start != start_buffer) begin
				start_buffer <= start;
			end
			if (start_buffer) begin
				buffer <= data;
				buffer_enable <= 1;
			end
			if ((state == 0) && sender_ready && buffer_enable) begin
				output_data <= buffer[31:24];
				state <= state + 1;
				valid <= 1;
			end else if ((state == 1) && sender_ready) begin
				output_data <= buffer[23:16];
				state <= state + 1;
			end else if ((state == 2) && sender_ready) begin
				output_data <= buffer[15:8];
				state <= state + 1;
			end else if ((state == 3) && sender_ready) begin
				output_data <= buffer[7:0];
				state <= state + 1;
			end else begin
				state <= 0;
				valid <= 0;
				buffer_enable <= 0;
			end
		end
	end
endmodule

