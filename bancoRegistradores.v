module bancoRegistradores(	clock, opcode, enderecoEscrita, enderecoReg1, enderecoReg2, enderecoReg3, indiceProcesso,
									sinalUC, dadoASerEscritoNoBancoReg, dado1, dado2, dado3, dadoEscrito);

	input clock, sinalUC;
	input [5:0] opcode;
	input [4:0] enderecoEscrita, enderecoReg1, enderecoReg2, enderecoReg3;
	input [31:0] dadoASerEscritoNoBancoReg;//dado a ser escrito no registrador
	input [3:0] indiceProcesso;
	
	//input [7:0] dadoBuffer;
	
	output [31:0] dado1, dado2, dado3, dadoEscrito;
	
	
	reg flagReg;
	reg [31:0] registradores [1:0][31:0];
	integer primeiroClock = 0;	
	
	always@(indiceProcesso or opcode) //se o programa for SO ou troca de contexto
	begin
		if (indiceProcesso == 0 && opcode != 6'd37 && opcode != 6'd38)
		begin
			flagReg = 0; //SO
		end
		else
			flagReg = 1; //Processos
	end
	
	
	always@(posedge clock) 
	begin
		if(primeiroClock)
		begin
			
			registradores[0][0] = 0;
			registradores[1][0] = 0;
			
//			registradores[2] = 10;
//			registradores[3] = 11;
//			registradores[4] = 55;
			
			primeiroClock <= 0;
			
		end
		
		
		if(sinalUC) 
		begin
			registradores[flagReg][enderecoEscrita] = dadoASerEscritoNoBancoReg;			
		end
		
		/*
		if(sinalUC) 
		begin
			registradores[flagReg][29] = buffer;			
		end
		*/
		
		registradores[1][5] = registradores[0][5];//para hdreg e reghd
		registradores[1][6] = registradores[0][6];//para hdreg e reghd
		
	end
	
	assign dado1 = registradores[flagReg][enderecoReg1]; 
	assign dado2 = registradores[flagReg][enderecoReg2];
	assign dado3 = registradores[flagReg][enderecoReg3];
	assign dadoEscrito = registradores[flagReg][enderecoEscrita];
	
	//assign dadoBuffer = registradores[flagReg][29];
	
endmodule	
