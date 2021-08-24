module contadorPrograma (	sinalUC, clock, enderecoEntrada, biosFinalizada, reset, flagHalt,
									indiceProxProc, PCProxProc,
									enderecoSaida, indiceProcesso, proximoPC);

	input [1:0] sinalUC;
	input clock, reset, flagHalt;
	input biosFinalizada;
	input [15:0] enderecoEntrada;
	input [4:0] indiceProxProc;
	input [15:0] PCProxProc;
	
	output reg [15:0] enderecoSaida;
	output reg [4:0] indiceProcesso;
	output reg [15:0] proximoPC;
	
	//parametros para troca de contexto
	reg [6:0] quantum;	
	localparam quantumMaximo = 300;	 
	
	initial
	begin
		indiceProcesso = 0; //BIOS e SO. Com isso o gerenciador de endereco vai executar a partir do endereco zero
	end	
	
	integer primeiraExecucaoBios = 1;
	integer primeiraExecucaoMemInstr = 1;
	
	always@(posedge clock) 
	begin
		//Reset geral do sistema
		if (reset)
		begin
			enderecoSaida = 16'd0;
			indiceProcesso = 5'd0;
			primeiraExecucaoMemInstr <= 1;
			primeiraExecucaoBios <= 1;
			quantum = 0;
			
		end
		else
		if (biosFinalizada == 0)
		begin
			//se é a primeira instrucao bios
			if (primeiraExecucaoBios) 
			begin
				enderecoSaida = 0;
				primeiraExecucaoBios <= 0;
			end

			else 
			begin
				if (sinalUC == 2'b00) 
				begin
					enderecoSaida = enderecoSaida + 16'd1;
				end
				if (sinalUC == 2'b01) 
				begin
					enderecoSaida = enderecoEntrada;
				end
				if (sinalUC == 2'b10) 
				begin
					enderecoSaida = enderecoSaida;
				end
				if (sinalUC == 2'b11) 
				begin
					enderecoSaida = 0;
				end
			end
		end
		
		else
		begin
			//se não tiver executado o quantum de instruções e não chegou na instrução halt
			if ((quantum < quantumMaximo) && (!flagHalt))
			begin
				if (primeiraExecucaoMemInstr)
				begin
					enderecoSaida = 0;
					primeiraExecucaoMemInstr <= 0;
					quantum = 0;
				end

				else
				begin
					if (sinalUC == 2'b00)
					begin
						enderecoSaida = enderecoSaida + 16'd1;
					end

					if (sinalUC == 2'b01)
					begin
						enderecoSaida = enderecoEntrada;
					end

					if (sinalUC == 2'b10)
					begin
						enderecoSaida = enderecoSaida;
					end

					if (sinalUC == 2'b11) //instrucao jProc
					begin
						enderecoSaida = PCProxProc;
						indiceProcesso = indiceProxProc;
					end
					
					if (indiceProcesso != 0)
					begin
						quantum = quantum + 7'd1;
					end
				end
			end

			//se instrução bateu o número de quantum ou terminou o programa (chegou na instrucao halt)
			else 
			begin
				if (sinalUC == 2'b00)
					proximoPC = enderecoSaida + 16'd1;
				else
					proximoPC = enderecoEntrada;
			
				quantum = 0;
				indiceProcesso = 5'd0;
				enderecoSaida = 16'd1; //troca de contexto			
			end			
			
		end
	end
	
endmodule