

module IDecoder(Instruction, RegWr, RegWSrc, RegWDst,
				ALUSrc1, ALUSrc2, ALUFn, MemWr, SignExtend, Shamt);
				
	input wire[31:0]	Instruction;

	output reg[3:0]	ALUFn;
	output reg	RegWr, ALUSrc1, ALUSrc2, MemWr;
	output wire RegWDst, RegWSrc, SignExtend;
	output wire[4:0]	Shamt;
	assign SignExtend = Instruction[31:28] != 4'b0011;//(add|x?or|lu)i
	assign RegWDst = Instruction[31:26] != 6'b000000;
	assign RegWSrc = Instruction[31:29] == 3'b100;
	assign Shamt = Instruction[31:26] == 6'b001111 ? 5'b10000 : Instruction[10:6];

	always @(Instruction) begin
		RegWr = 1'b0;
		ALUSrc1 = 1'b0;
		MemWr = Instruction[31:29] == 3'b101;
		case (Instruction[31:26])
		6'd0: begin
			RegWr = 1'b1;
			if (Instruction[5:3] == 3'b0) begin
				ALUSrc1 = 1'b1;
			end

			case (Instruction[5:0])
			6'd0:	ALUFn = `ALUFN_SLL;	
			6'd2:	ALUFn = Instruction[21] ? `ALUFN_ROTR : `ALUFN_SRL;
			6'd3:	ALUFn = `ALUFN_SRA;
			6'd4:	ALUFn = `ALUFN_SLL;
			6'd6:	ALUFn = Instruction[21] ? `ALUFN_ROTR : `ALUFN_SRL;
			6'd7:	ALUFn = `ALUFN_SRA;
			6'd32:	ALUFn = `ALUFN_ADD;
			6'd33:	ALUFn = `ALUFN_ADD;
			6'd34:	ALUFn = `ALUFN_SUB;
			6'd35:	ALUFn = `ALUFN_SUB;
			6'd36:	ALUFn = `ALUFN_AND;
			6'd37:	ALUFn = `ALUFN_OR;
			6'd38:	ALUFn = `ALUFN_XOR;
			6'd39:	ALUFn = `ALUFN_NOR;
			endcase
		end
		6'd8:	ALUFn = `ALUFN_ADD;
		6'd9:	ALUFn = `ALUFN_ADD;
		6'd12:	ALUFn = `ALUFN_AND;
		6'd13:	ALUFn = `ALUFN_OR;
		6'd14:	ALUFn = `ALUFN_XOR;
		6'd15:	begin	ALUFn = `ALUFN_SLL;	ALUSrc1 = 1'b1;	end
		default: ALUFn = 4'b0; 
		endcase
		if (Instruction[31:29] == 3'b001)
			ALUSrc2 = 1'b1;
		else
			ALUSrc2 = 1'b0;

		if (ALUSrc2 == 1'b1) RegWr = 1'b1;
	end

endmodule
