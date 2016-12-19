module inst_memory #( //$BA0Ds!'(Bloader_ready$B$O0l=V$7$+>e$,$i$J$$(B
	parameter INST_MEM_WIDTH = 5
) (
	input logic CLK,
	input logic reset,
	input logic [INST_MEM_WIDTH-1:0] pc,
	output logic [31:0] inst,
	output logic distinct
);
	logic [31:0] inst_buffer;
	logic [2:0] state;

	inst_mem_bl inst_mem_bl(
			.addra(pc),
			.clka(CLK),
			.dina(32'h08000000),
			.douta(inst),
			.ena(1'b1),
			.wea(1'b0)
	);

	always_ff @(posedge CLK) begin
		if (reset) begin
			inst_buffer <= 0;
			distinct <= 1;
		end else begin
			if (inst != inst_buffer) begin
				distinct <= 1;
				inst_buffer <= inst;
			end else begin
				distinct <= 0;
			end
		end
	end
endmodule
