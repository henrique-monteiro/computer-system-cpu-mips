module gerenciadorEnderecos(	enderecoInstrucao, indicePrograma, setor, trilha, enderecoEscritaMemInstr, 
										indiceProcesso, enderecoLeituraEscritaMemDados,
										novoEnderecoEscritaMemInstr, novoEnderecoLeituraMemInstr, 
										novoEnderecoLeituraEscritaHD, novoEnderecoLeituraEscritaMemDados);

	input [15:0] enderecoInstrucao;
	input [4:0] indicePrograma;
	input [4:0] indiceProcesso;
	input [4:0] setor;
   input [31:0] trilha;
	
	
	//HD
	input [15:0] enderecoEscritaMemInstr; //vem da instrucao hdmi para calcular o endereco de escrita da memInstr
	output [15:0] novoEnderecoLeituraEscritaHD; //hdmd
	
	//Mem Instr
	output [15:0] novoEnderecoEscritaMemInstr; //hdmi
	output [15:0] novoEnderecoLeituraMemInstr;
	
	//Mem Dados
	input [15:0] enderecoLeituraEscritaMemDados;
	output [15:0] novoEnderecoLeituraEscritaMemDados;
	
	
	wire [31:0] auxEnderecoLeituraMemInstr;
	wire [31:0] auxEnderecoEscritaMemInstr;
	wire [31:0] auxEnderecoLeituraEscritaHD;
	wire [31:0] auxEnderecoLeituraEscritaMemDados;	
	
	
	//Calculos	
	
	//enderecoEscritaMemInstr:	em hdmi eh usado na BIOS e no prompt para copiar as instrucoes do HD para a memInstr dos programas 
	//						selecionados pelo usuario. Vai de zero ate a ultima instrucao do S.O. ou programa
	assign auxEnderecoEscritaMemInstr = ((indicePrograma*500) + enderecoEscritaMemInstr); 
	
	//setor: 	em hdmi eh zero (S.O.); (leitura) 
	//				em hdmd e hdreg eh o indice do processo (1 a 10); (leitura) 
	//				em reghd indiceUltimoProcesso (salvar contexto) (escrita)
	//trilha:	em hdmi eh 100 ate o endereco da ultima instrucao do SO (leitura)
	//				em hdmd (leitura)
	//				em reghd eh a trilhafim + 1 (salva os dados dos reg a partir da ultima instrucao do ultimo processo executado
	assign auxEnderecoLeituraEscritaHD = ((3*setor) + trilha[15:0]);
	
	
	
	//enderecoInstrucao eh o endereco que sai do PC (todas as instrucoes) gerado pelo compilador
	assign auxEnderecoLeituraMemInstr = ((indiceProcesso * 500) + enderecoInstrucao);	
	
	
	
	
	//indiceProcesso:						em hdmd eh o indice do processo que vai buscar a trilha tamanho, inicio ou fim
	//											em load, loadi, store, etc ja fica setada pelo PC atraves da instrucao JumpProcesso
	//enderecoLeituraEscritaMemDados:em hdmd eh o endereco da variavel (que vai receber o dado) gerado pelo compilador
	//											em load, loadi, store, etc tambem eh o endereco gerado pelo compilador
	//											
	assign auxEnderecoLeituraEscritaMemDados = ((indiceProcesso * 100) + enderecoLeituraEscritaMemDados);
	
	
    
	//Saidas
	assign novoEnderecoLeituraMemInstr = auxEnderecoLeituraMemInstr[15:0];
	assign novoEnderecoEscritaMemInstr = auxEnderecoEscritaMemInstr[15:0];
	assign novoEnderecoLeituraEscritaHD = auxEnderecoLeituraEscritaHD[15:0];
	assign novoEnderecoLeituraEscritaMemDados = auxEnderecoLeituraEscritaMemDados[15:0];
endmodule