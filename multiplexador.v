module multiplexador(	input[2:0] sinalUC, 
								input[31:0] entradaMemoriaDados, entradaExterna, entradaALU, buffer, 
								input[31:0] entradaBancoRegistradores,	entradaImediatoExtendido, 
								output reg[31:0] saidaMUX);
								//imediato extendido (loadi)
								
	always@(*) begin
		case(sinalUC)
			0: saidaMUX = entradaALU;
			1: saidaMUX = entradaExterna;
			2: saidaMUX = entradaMemoriaDados;
			3: saidaMUX = entradaBancoRegistradores;//move
			4: saidaMUX = entradaImediatoExtendido; //load imediato
			5: saidaMUX = {24'd0,buffer};
			
			default: saidaMUX = 32'bx;
		endcase
	end
	
endmodule
