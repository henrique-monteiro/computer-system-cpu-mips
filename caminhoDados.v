module caminhoDados(	input clock50M, reset, flagPause, 
							input[15:0] valorChavesEntrada,							
							output reg led_entrada, flagHalt,								
							output[6:0] displayInstrucaoMilhar, displayInstrucaoCentena, displayInstrucaoDezena, displayInstrucaoUnidade,
							output[6:0] displayMilhar, displayCentena, displayDezena, displayUnidade);

							
	unidadeControle UC(.clock(clock),	
							 .reset(reset), 
							 .opcode(opcode),
							 .sinalSaida(sinalSaida), 
							 .sinalBranch(sinalBranch), 
							 .sinalPC(sinalPC), 
							 .sinalEscritaMemoriaInstrucao(sinalEscritaMemoriaInstrucao),
							 .sinalEscritaMemoriaDados(sinalEscritaMemoriaDados), 
							 .sinalEscritaBanco(sinalEscritaBanco),
							 .sinalEscritaHD(sinalEscritaHD), 
							 .sinalExtensorParaALUouMem(sinalExtensorALUouMemDados),
							 .sinalExtensorParaEntrada(sinalExtensorEntrada),
							 .sinalExtensorParaBranchJump(sinalExtensorBranchsJump), 
							 .sinalMUX(sinalMUX),
							 .sinalModuloTxHabilitado(sinalModuloTxHabilitado));						
							
							
	contadorPrograma PC(	.sinalUC(sinalPC),
								.clock(clock),
								.biosFinalizada(biosFinalizada),
								.reset(reset),
								.flagHalt(flagHalt),
								.indiceProxProc(indiceProxProc),
								.PCProxProc(PCProxProc),
								.enderecoEntrada(enderecoProximaInstrucao),
								.indiceProcesso(program_executing),
								.enderecoSaida(enderecoInstrucao),
								.proximoPC(proximoPC));
								
	bios bios(	.clock(clock), 
					.reset(reset),
					.enderecoProximaInstrucao(enderecoInstrucao), 
					.proximaInstrucao(instrucaoBios), 
					.biosFinalizada(biosFinalizada));								

										
	simple_dual_port_ram_dual_clock_mem_instr mem_intr(	.data(saidaHD), 
																			.read_addr(novoEnderecoLeituraMemInstr),
																			.write_addr(novoEnderecoEscritaMemInstr),
																			.we(sinalEscritaMemoriaInstrucao),
																			.read_clock(clock50M),
																			.write_clock(clock),
																			.q(instrucaoMEM));
	
	simple_dual_port_ram_dual_clock_hd hd(	.data(dadoASerEscritoNoHD), 
														.read_addr(novoEnderecoLeituraEscritaHD),
														.write_addr(novoEnderecoLeituraEscritaHD),
														.we(sinalEscritaHD), 
														.read_clock(clock50M),
														.write_clock(clock),
														.q(saidaHD));
														
	
	bancoRegistradores BancoReg(	.clock(clock),
											.opcode(opcode),
											.enderecoEscrita(enderecoRegistradorEscrita),
											.enderecoReg1(enderecoReg1),
											.enderecoReg2(enderecoReg2),
											.enderecoReg3(enderecoReg3),											
											.sinalUC(sinalEscritaBanco),			
											.dadoASerEscritoNoBancoReg(dadoASerEscritoNoBancoReg), 
											.dado1(dadoReg1),
											.dado2(dadoReg2),
											.dado3(dadoReg3),
											.dadoEscrito(dadoEscrito),
											.indiceProcesso(program_executing)); 
								
	unidadeLogicaAritmetica ALU(	.opcode(opcode),
											.dado1(dadoALU1),
											.dado2(dadoALU2),
											.imediatoExtendido(imediatoExtendidoALU),
											.constanteExtendido(constanteExtendidoALU),
											.saidaALU(saidaALU));
	
									
	simple_dual_port_ram_dual_clock_mem_dados mem_dados(	.data(dadoASerEscritoNaMemDados), 
																			.read_addr(novoEnderecoLeituraEscritaMemDados),
																			.write_addr(novoEnderecoLeituraEscritaMemDados),
																			.we(sinalEscritaMemoriaDados), 
																			.read_clock(clock50M),
																			.write_clock(clock),
																			.q(dadoASerEscritoNoBancoLoad));
																			
	gerenciadorEnderecos gerenciaEnd(	.enderecoInstrucao(enderecoInstrucao),
													.enderecoLeituraEscritaMemDados(enderecoLeituraEscritaMemDados),
													.indicePrograma(indicePrograma),
													.enderecoEscritaMemInstr(enderecoEscritaMemInstr),
													.setor(setor),
													.trilha(trilha),
													.indiceProcesso(program_executing),
													.novoEnderecoEscritaMemInstr(novoEnderecoEscritaMemInstr),
													.novoEnderecoLeituraMemInstr(novoEnderecoLeituraMemInstr),
													.novoEnderecoLeituraEscritaHD(novoEnderecoLeituraEscritaHD),
													.novoEnderecoLeituraEscritaMemDados(novoEnderecoLeituraEscritaMemDados));
						
	extensorBits extALUouMem(	.sinalUC(sinalExtensorALUouMemDados),
										.sinal16(valorImediato),
										.sinal32(valorImediatoExtendido));
						
									
	extensorBits extBJ(	.sinalUC(sinalExtensorBranchsJump),
								.sinal16(enderecoBranchsJump),
								.sinal32(enderecoBranchsJumpExtendido));
											
	extensorBits extEntrada(.sinalUC(sinalExtensorEntrada),
									.sinal16(valorEntrada),
									.sinal32(valorEntradaExtendido));
								
						
	multiplexador MUX(.sinalUC(sinalMUX),
							.entradaMemoriaDados(entradaMemoriaDados),
							.entradaExterna(entradaExterna),
							.entradaALU(entradaALU),
							.entradaImediatoExtendido(entradaImediatoExtendido),
							.entradaBancoRegistradores(entradaBancoRegistradores),
							.buffer(buffer),
							.saidaMUX(saidaMUX));
							
	saida s(numeroASerExibido, 
					clock, 
					sinalSaida, 
					
					displayMilhar,
					displayCentena, 
					displayDezena, 
					displayUnidade);
					
	Display IM(	.sinalSaida(1),
					.entrada(instrucaoMilhar),
					.saida(displayInstrucaoMilhar));
					
	Display IC(	.sinalSaida(1),
					.entrada(instrucaoCentena),
					.saida(displayInstrucaoCentena));
	
	Display ID(	.sinalSaida(1),
					.entrada(instrucaoDezena),
					.saida(displayInstrucaoDezena));
		
		
	Display IU(	.sinalSaida(1),
					.entrada(instrucaoUnidade),
					.saida(displayInstrucaoUnidade));
					
	temporizador temp	(	.clock50M(clock50M),
								.opcode(opcode),
								.flagPause(flagPause),								
								.clock(clock)); 
								
	geradorTick gT (	.clock50M(clock50M),
							.reset(1),
							.baudrate(baudrate),
							.tick(tick));
							
	RX rx(	.clock50M(clock50M),
				.reset(1),
				.moduloRxHabilitado(1),
				.tick(tick),
				.bitInRX(bitOutTX),
				.nBits(nBits),
				.buffer(buffer));
				
	TX tx(	.clock50M(clock50M),
				.reset(1),
				.moduloTxHabilitado(moduloTxHabilitado),
				.tick(tick),
				.nBits(nBits),
				.dadoASerEnviado(dadoASerEnviado),
				.bitOutTX(bitOutTX));
				
					


	wire clock;
	
	//Unidade de controle
	wire sinalEntrada, sinalSaida, sinalBranch, sinalEscritaMemoriaInstrucao, sinalEscritaMemoriaDados, sinalEscritaBanco, sinalEscritaHD, sinalExtensorALUouMemDados,
		  sinalExtensorEntrada, sinalExtensorBranchsJump, sinalModuloTxHabilitado;
	wire[1:0] sinalPC;
	wire[5:0] opcode;
	wire[2:0] sinalMUX;
	assign opcode = instrucao[31:26];
	assign sinalBranch = saidaALU[0];
	
	//PC
	wire[15:0] enderecoInstrucao;
	reg[4:0] indiceProxProc;
	reg[15:0] PCProxProc;
	reg[15:0] enderecoProximaInstrucao;
	wire [15:0] proximoPC;
		
	//Memeoria de Instruções
	wire [31:0] instrucaoMEM;
	reg [15:0]enderecoInstrucaoEscritaMemoriaInstrucao;	
	
	wire [31:0] instrucao;
	
	//HD
	wire [31:0] saidaHD;
	reg[15:0]enderecoASerBuscadaNaHD;
	reg [31:0] dadoASerEscritoNoHD;
	
	//GerenciadorEnderecos
	reg[4:0] indicePrograma;
	reg[4:0] setor;
	reg[31:0] trilha;
	reg[15:0] enderecoEscritaMemInstr;
		
	wire [4:0] program_executing;
	wire [15:0] novoEnderecoLeituraEscritaHD;
	wire [15:0] novoEnderecoEscritaMemInstr;
	wire [15:0] novoEnderecoLeituraMemInstr;
	wire [15:0] novoEnderecoLeituraEscritaMemDados;	
	
	
	//Bios
	wire [31:0]instrucaoBios;
	wire biosFinalizada;	

	assign instrucao = (biosFinalizada) ? instrucaoMEM : instrucaoBios;
	
	//banco de Registradores
	reg[4:0] enderecoRegistradorEscrita, enderecoReg1, enderecoReg2, enderecoReg3;
	reg[31:0] dadoASerEscritoNoBancoReg;
	wire[31:0] dadoReg1, dadoReg2, dadoReg3, dadoEscrito;
	
	//ULA
	reg[31:0] dadoALU1,dadoALU2;
	wire[31:0] saidaALU;
	reg[31:0] imediatoExtendidoALU, constanteExtendidoALU;
	
	//MUX
	reg[31:0] entradaMemoriaDados, entradaExterna, entradaALU, entradaImediatoExtendido, entradaBancoRegistradores;
	wire[31:0] saidaMUX;
	
	//extensor de Bits para ALU
	reg[15:0] valorImediato;
	wire[31:0] valorImediatoExtendido;
	
	//memoria de dados
	reg[31:0] dadoASerEscritoNaMemDados;
	reg[15:0] enderecoLeituraEscritaMemDados;
	wire[31:0] dadoASerEscritoNoBancoLoad;

	//extensor de bits para Branch's e Jump
	reg[15:0] enderecoBranchsJump;
	wire[31:0] enderecoBranchsJumpExtendido;
	
	//extensor de bits para entrada
	reg[15:0] valorEntrada;
	wire[31:0]valorEntradaExtendido;
	
	//saida
	reg[31:0] numeroASerExibido;
	
	//mostrar a instrucao no display
	reg [31:0] instrucaoASerMostrada;//aqui
	reg [3:0] instrucaoUnidade, instrucaoDezena, instrucaoCentena, instrucaoMilhar;//aqui
	integer i;
	
	//geradorTick
	parameter baudrate = 32'd9600;
	parameter nBits = 4'b1000;			//numero de bits que vai enviar e receber
	
	//TX
	reg[7:0] dadoASerEnviado;
	wire bitOutTX;
	reg moduloTxHabilitado;
	
	//RX
	wire[31:0] buffer;
	
	always@(*) 
	begin		
		enderecoRegistradorEscrita = 0;
		enderecoReg1 = 0;
		enderecoReg2 = 0;
		enderecoReg3 = 0;
		dadoALU1 = 0;
		dadoALU2 = 0;
		entradaALU = 0;
		dadoASerEscritoNoBancoReg = 0;
		dadoASerEnviado = 0;
		indicePrograma = 0;
		enderecoEscritaMemInstr = 0;
		indiceProxProc = 0;
		PCProxProc = 0;
		entradaBancoRegistradores = 0;
		setor = 0;
		trilha = 0;
		dadoASerEscritoNoHD = 0;
		dadoASerEscritoNaMemDados = 0;
		enderecoLeituraEscritaMemDados = 0;
		valorImediato = 0;
		enderecoProximaInstrucao = 0;
		numeroASerExibido = 0;
		//extensorBits = 0;
		//entradaMemoridaDados = 0;
		//entradaExterna = 0;
		entradaImediatoExtendido = 0;
		imediatoExtendidoALU = 0;
		valorEntrada = 0;
		flagHalt = 0;
		
		
		case(opcode) 
			0: //add formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;		
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			1: //sub formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			2: //addi formato 2
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					valorImediato = instrucao[15:0];
					dadoALU1 = dadoReg1;
					imediatoExtendidoALU = valorImediatoExtendido; 
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			3: //subi formato 2
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					valorImediato = instrucao[15:0];
					dadoALU1 = dadoReg1;
					imediatoExtendidoALU = valorImediatoExtendido; 
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			4: //and formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			5: //or formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			6: //slt formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end	
			7: //slet formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end				
			8: //sgt formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;		
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			9: //sget formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end					
			10: //set formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;		
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			11: //sdt formato 1
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					enderecoReg2 = instrucao[15:11];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;		
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			12: //andi formato 2
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					valorImediato = instrucao[15:0];
					dadoALU1 = dadoReg1;
					imediatoExtendidoALU = valorImediatoExtendido;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			13: //ori formato 2
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					valorImediato = instrucao[15:0];
					dadoALU1 = dadoReg1;
					imediatoExtendidoALU = valorImediatoExtendido;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			14: //slti formato 2
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					valorImediato = instrucao[15:0];
					dadoALU1 = dadoReg1;
					imediatoExtendidoALU = valorImediatoExtendido;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			15: //not formato 4 verificar depois
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					dadoALU1 = dadoReg1;
					entradaALU = saidaALU;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end

			16: //load formato 7
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoLeituraEscritaMemDados = instrucao[20:5];					
					entradaMemoriaDados = dadoASerEscritoNoBancoLoad;
					dadoASerEscritoNoBancoReg = saidaMUX;	
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			17: //store formato 7
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoLeituraEscritaMemDados = instrucao[20:5];
					 
					dadoASerEscritoNaMemDados = dadoReg1;
					
					//ledEntrada = 0;
					flagHalt = 0;
					moduloTxHabilitado = 0;				
				end
			18: //loadi formato 7: não busca na memoria, apenas salva o imediato no registrador
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					valorImediato = instrucao[20:5];
					entradaImediatoExtendido = valorImediatoExtendido; // não busca nada na memoria
					dadoASerEscritoNoBancoReg = saidaMUX;
					//ledEntrada = 0;
					flagHalt = 0;
					moduloTxHabilitado = 0;				
				end
			19: //loadr formato 2
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];					
					enderecoLeituraEscritaMemDados = dadoReg1;	
					entradaMemoriaDados = dadoASerEscritoNoBancoLoad;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			20: //storer formato 2
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoReg2 = instrucao[20:16];
					enderecoLeituraEscritaMemDados= dadoReg2;
					dadoASerEscritoNaMemDados = dadoReg1;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			21: //move formato 4
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					enderecoReg1 = instrucao[20:16];
					entradaBancoRegistradores = dadoReg1;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 0;	
					moduloTxHabilitado = 0;								
				end
			22: //beq formato 2
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoReg2 = instrucao[20:16];
					//enderecoBranchsJump = instrucao[15:0];
					enderecoProximaInstrucao = instrucao[15:0];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;					
					//enderecoProximaInstrucao = enderecoBranchsJumpExtendido;
					flagHalt = 0;
					moduloTxHabilitado = 0;				
					//ledEntrada = 0;
				end
			23: //bne formato 2
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoReg2 = instrucao[20:16];
					//enderecoBranchsJump = instrucao[15:0];					
					enderecoProximaInstrucao = instrucao[15:0];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					//enderecoProximaInstrucao = enderecoBranchsJumpExtendido;
					flagHalt = 0;
					moduloTxHabilitado = 0;				
					//ledEntrada = 0;
				end
			24: //bgt formato 2
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoReg2 = instrucao[20:16];
					//enderecoBranchsJump = instrucao[15:0];
					enderecoProximaInstrucao = instrucao[15:0];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					//enderecoProximaInstrucao = enderecoBranchsJumpExtendido;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			25: //blt formato 2
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoReg2 = instrucao[20:16];
					//enderecoBranchsJump = instrucao[15:0];
					enderecoProximaInstrucao = instrucao[15:0];
					dadoALU1 = dadoReg1;
					dadoALU2 = dadoReg2;
					//enderecoProximaInstrucao = enderecoBranchsJumpExtendido;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			26: //j formato 5
				begin
					//enderecoBranchsJump = instrucao[25:10];		
					enderecoProximaInstrucao = instrucao[25:10];
					//enderecoProximaInstrucao = enderecoBranchsJumpExtendido;	
					flagHalt = 0;
					//ledEntrada = 0;	
					moduloTxHabilitado = 0;								
				end
			27: //jr formato 6
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoProximaInstrucao = dadoReg1;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
			28: //nop formato 3
				begin
				flagHalt = 0;
					//ledEntrada = 0;
				end
			29: //hlt formato 3
				begin
					flagHalt = 1;
					//ledEntrada = 0;
				end
			30: //in formato 6
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					valorEntrada = valorChavesEntrada;
					entradaExterna = valorEntradaExtendido;
					dadoASerEscritoNoBancoReg = saidaMUX;
					flagHalt = 0;
					//ledEntrada = 1;
					moduloTxHabilitado = 0;				
				end
			31: //out formato 6
				begin
					enderecoReg1 = instrucao[25:21];
					numeroASerExibido = dadoReg1;
					flagHalt = 0;
					//ledEntrada = 0;
					moduloTxHabilitado = 0;				
				end
				
			32://hdmi
				begin
					enderecoReg1 = instrucao[25:21]; //idPrograma (0 para SO)
					enderecoReg2 = instrucao[20:16];//trilha
					enderecoReg3 = instrucao[15:11];//endereco HD gerado pela BIOS 
					
					setor = 5'd0; //Sistema operacional ("indicePrograma" igual a zero					
					trilha = dadoReg2; //eh o endereco da primeira instrucao do indicePrograma					
					
					enderecoEscritaMemInstr = dadoReg3[15:0]; // 0<k<enderecoUltimaInstrucao
					indicePrograma = dadoReg1[4:0]; //equivalente a indiceProcesso					
				end
				
			33://hdmd
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoReg2 = instrucao[20:16];
					enderecoReg3 = instrucao[15:11];
					
										
					setor = dadoReg1[4:0];
					trilha = dadoReg2;					
					
					enderecoLeituraEscritaMemDados = dadoReg3[15:0];
					
					dadoASerEscritoNaMemDados = saidaHD;					
				end
				
			34://jumpProcesso
				begin
					enderecoReg1 = instrucao[25:21];
					enderecoReg2 = instrucao[20:16];
					
					indiceProxProc = dadoReg1[4:0];
					PCProxProc = dadoReg2[15:0];					
				end
				

			36://StorePC 
				begin
					enderecoLeituraEscritaMemDados = instrucao[20:5];				
					dadoASerEscritoNaMemDados = proximoPC;
					
					flagHalt = 0;
				end
				
			37://hdreg
				begin
					enderecoReg1 = instrucao[25:21];//endereco do registrador que tem o endereco do HD do dadoASerEscritoBancoReg
					enderecoReg2 = instrucao[20:16];//endereco do registrador que tem a trilha
										
					setor = 0;
					trilha = dadoReg2;//endereco da ultima instrucao do programa no HD + 1 
					enderecoRegistradorEscrita = dadoReg1[4:0];//endereço que o dado vai ser gravado no Bando de registradores
					
					dadoASerEscritoNoBancoReg= saidaHD;
					
					
				end
				
			38://reghd
				begin
					enderecoReg1 = instrucao[25:21];//endereço do registrador que contem o dadoASerEscritoNoHD
					enderecoReg2 = instrucao[20:16];//trilha					
					
					setor = 0;
					trilha = dadoReg2;//endereco da ultima instrucao do programa no HD + 1					
					
					enderecoRegistradorEscrita = dadoReg1[4:0];//para este caso especifico foi usado o dadoEscrito no banco como dadoASerGravadonoHD				
					dadoASerEscritoNoHD = dadoEscrito;				
					
				end
				
			35: //interrupt formato 3
				begin
					//ledEntrada = 0;
				end
				
			40: //receive
				begin
					enderecoRegistradorEscrita = instrucao[25:21];
					dadoASerEscritoNoBancoReg = saidaMUX;	
					moduloTxHabilitado = 0;				
					
				end	
			41: //send
				begin
					enderecoReg1 = instrucao[25:21];
					dadoASerEnviado = dadoReg1[7:0];
					moduloTxHabilitado = 1;
					
				end
		
	

		endcase
		//instrucaoAtual = enderecoInstrucao; //para mostrar no waveform
		
		//reg1 = dadoReg1;
		//reg2 = dadoReg2; 
		//resul = saidaMUX;
	end
	
	//para mostrar a instrucao atual no display
	always @(*)	
		begin
			instrucaoASerMostrada = novoEnderecoLeituraMemInstr;
			instrucaoUnidade = 0;
			instrucaoDezena = 0;
			instrucaoCentena = 0;
			instrucaoMilhar = 0;		
		
			for (i=13; i>=0; i=i-1)
			begin
				if(instrucaoMilhar >= 5)
					instrucaoMilhar = instrucaoMilhar + 3;			
				if(instrucaoCentena >= 5)
					instrucaoCentena = instrucaoCentena + 3;
				if(instrucaoDezena >= 5)
					instrucaoDezena = instrucaoDezena + 3;
				if(instrucaoUnidade >= 5)
					instrucaoUnidade = instrucaoUnidade + 3;
					
				instrucaoMilhar = instrucaoMilhar << 1;
				instrucaoMilhar[0] = instrucaoCentena[3];
				instrucaoCentena = instrucaoCentena << 1;
				instrucaoCentena[0] = instrucaoDezena[3];
				instrucaoDezena = instrucaoDezena << 1;
				instrucaoDezena[0] = instrucaoUnidade[3];
				instrucaoUnidade = instrucaoUnidade << 1;
				instrucaoUnidade[0] = instrucaoASerMostrada[i];
			end
		end
		
endmodule
				
					
					
					