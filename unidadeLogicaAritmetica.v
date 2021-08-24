module unidadeLogicaAritmetica(opcode, dado1, dado2, imediatoExtendido, constanteExtendido, saidaALU);

	input [5:0] opcode;
	input [31:0] dado1, dado2, imediatoExtendido, constanteExtendido;
	
	output reg [31:0] saidaALU;
	
	always@(*) begin
		case(opcode)
			0: //add
				saidaALU = dado1 + dado2;
			1: //sub
				saidaALU = dado1 - dado2;
			2: //addi
				saidaALU = dado1 + imediatoExtendido;
			3: //subi
				saidaALU = dado1 - imediatoExtendido;
			4: //and
				saidaALU = dado1 & dado2;
			5: //or
				saidaALU = dado1 | dado2;
			6: //slt
				if(dado1 < dado2) //slt
					saidaALU = 1;
				else
					saidaALU = 0;
			7: //slet
				if(dado1 <= dado2) //slt
					saidaALU = 1;
				else
					saidaALU = 0;					
			8: //sgt
				if(dado1 > dado2) //slt
					saidaALU = 1;
				else
					saidaALU = 0;
			9: //sget
				if(dado1 >= dado2) //slt
					saidaALU = 1;
				else
					saidaALU = 0;					
			10: //set
				if(dado1 == dado2) //slt
					saidaALU = 1;
				else
					saidaALU = 0;
			11: //sdt
				if(dado1 != dado2) //slt
					saidaALU = 1;
				else
					saidaALU = 0;
			12: //andi
				saidaALU = dado1 & imediatoExtendido;
			13: //ori
				saidaALU = dado1 | imediatoExtendido;
			14: //slti
				if(dado1 < imediatoExtendido)
					saidaALU = 1;
				else
					saidaALU = 0; 
			15: //not
				saidaALU = ~dado1;
			22: //beq
				if(dado1 == dado2)
					saidaALU = 32'd1; //saidaALU = 00000000000000000000000000000001 (verificar apenas saidaALU[0])
				else
					saidaALU = 32'd0;
			23: //bne
				if(dado1 == dado2)
					saidaALU = 32'd0; //saidaALU = 00000000000000000000000000000000 (verificar apenas saidaALU[0])
				else
					saidaALU = 32'd1;
			24: //bgt
				if(dado1 > dado2)
					saidaALU = 32'd1; //saidaALU = 00000000000000000000000000000001 (verificar apenas saidaALU[0])
				else
					saidaALU = 32'd0;
			25: //blt
				if(dado1 < dado2)
					saidaALU = 32'd1; //saidaALU = 00000000000000000000000000000001 (verificar apenas saidaALU[0])
				else
					saidaALU = 32'd0;
			
			//aqui em defaul servira para as instruções que "não utilizam" a ALU
			default saidaALU = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
	end
endmodule
		