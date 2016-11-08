module receiver_buffer(
	input logic CLK,
	input logic [7:0] data,
	input logic valid,
	output logic [31:0] input_data,
	output logic ready
);
	integer state = 0;
	logic [31:0] buffer;

	always_ff @(posedge CLK) begin
		case (state)
			0 : begin
					if (valid) begin
						buffer[31:24] <= data;
						state <= state + 1;
				    end else begin
						ready <= 0;
				    end
				end
			1 : begin
					if (valid) begin
						buffer[23:16] <= data;
						state <= state + 1;
					end
				end
			2 : begin
					if (valid) begin
						buffer[15:8] <= data;
						state <= state + 1;
					end
				end
			3 : begin
					if (valid) begin
						buffer[7:0] <= data;
						state <= state + 1;
					end
				end
			4 : begin
					input_data <= buffer;
					ready <= 1;
					state <= 0;
				end
		endcase
	end
endmodule
