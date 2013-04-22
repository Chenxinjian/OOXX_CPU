`include "Define.v"


module ALU(In1, In2, Out, Gz, Ez, Lz, Eq, ALUFn);
	input wire[31:0]	In1, In2;
	input wire[ 3:0]	ALUFn;
	output reg[31:0]	Out;
	output wire	Gz, Ez, Lz, Eq;

	assign Ez = In1 == 32'b0;
	assign Lz = In1[31] == 1'b1;
	assign Gz = (In1[31] == 1'b0) && ~Ez;
	assign Eq = In1 == In2;

	always @(In1 or In2 or ALUFn) begin
		case (ALUFn)
		`ALUFN_ADD:	Out = In1 + In2;
		`ALUFN_SUB: Out = In1 - In2;
		`ALUFN_SLL: Out = In2 << In1;
		`ALUFN_SRL: Out = In2 >> In1;
		`ALUFN_SRA: Out = {{32{In2[31]}}, In2} >> In1;
		`ALUFN_ROTR:Out = {2{In2[31:0]}} >> In1;
		`ALUFN_AND: Out = In1 & In2;
		`ALUFN_OR:	Out = In1 | In2;
		`ALUFN_XOR:	Out = In1 ^ In2;
		`ALUFN_NOR:	Out = In1 ~| In2;
		endcase
	end
endmodule
