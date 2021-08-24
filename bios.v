module bios (clock, reset, enderecoProximaInstrucao, proximaInstrucao, biosFinalizada);

	input clock;
	input reset;
	input [15:0] enderecoProximaInstrucao;
	output [31:0] proximaInstrucao;
	output reg biosFinalizada;
	
	localparam tamanhoBios = 52;

	reg [31:0] instrucaoBIOS[tamanhoBios:0];
	
	assign proximaInstrucao = instrucaoBIOS [enderecoProximaInstrucao];
	
	integer start = 1;
	integer primeiraExecucaoBios = 1;	
	
	always@(posedge clock)
	begin
	
		if (reset)
		begin
			biosFinalizada = 0;
			primeiraExecucaoBios = 1;
		end
		
		else
		if (primeiraExecucaoBios)//qndo acaba de dar start ou acaba de "sair" do reset
		begin
			if (enderecoProximaInstrucao >= tamanhoBios)//se ja executou todas as instrucoes da bios
			begin
				biosFinalizada = 1;
				primeiraExecucaoBios = 0;
			end
			else//esta executando a bios (nao chegou na ultima instrucao)
			begin
				biosFinalizada = 0;
				primeiraExecucaoBios = 1;
			end
		end	
		else//se ja executou a bios por completa
		begin
			biosFinalizada = 1;
			primeiraExecucaoBios = 0;
		end
	end
	
	
	
	always@(posedge clock) begin
		
		if (start)
		begin				
			instrucaoBIOS[0] <= { 6'd26, 16'd1, 10'd0 };
			instrucaoBIOS[1] <= { 6'd18, 5'd1, 16'd5, 5'd0 };
			instrucaoBIOS[2] <= { 6'd17, 5'd1, 16'd7, 5'd0 };
			instrucaoBIOS[3] <= { 6'd18, 5'd1, 16'd0, 5'd0 };
			instrucaoBIOS[4] <= { 6'd17, 5'd1, 16'd2, 5'd0 };
			instrucaoBIOS[5] <= { 6'd18, 5'd1, 16'd100, 5'd0 };
			instrucaoBIOS[6] <= { 6'd17, 5'd1, 16'd3, 5'd0 };
			instrucaoBIOS[7] <= { 6'd18, 5'd1, 16'd0, 5'd0 };
			instrucaoBIOS[8] <= { 6'd17, 5'd1, 16'd4, 5'd0 };
			instrucaoBIOS[9] <= { 6'd18, 5'd1, 16'd310, 5'd0 };//tamanho do SO
			instrucaoBIOS[10] <= { 6'd17, 5'd1, 16'd5, 5'd0 };
			instrucaoBIOS[11] <= { 6'd18, 5'd1, 16'd0, 5'd0 };
			instrucaoBIOS[12] <= { 6'd17, 5'd1, 16'd0, 5'd0 };
			instrucaoBIOS[13] <= { 6'd30, 5'd10, 21'd0 };
			instrucaoBIOS[14] <= { 6'd17, 5'd10, 16'd6, 5'd0 };
			instrucaoBIOS[15] <= { 6'd16, 5'd1, 16'd7, 5'd0 };
			instrucaoBIOS[16] <= { 6'd16, 5'd2, 16'd6, 5'd0 };
			instrucaoBIOS[17] <= { 6'd0, 5'd11, 5'd1, 5'd2, 11'd0 };
			instrucaoBIOS[18] <= { 6'd17, 5'd11, 16'd7, 5'd0 };
			instrucaoBIOS[19] <= { 6'd16, 5'd1, 16'd2, 5'd0 };
			instrucaoBIOS[20] <= { 6'd16, 5'd2, 16'd5, 5'd0 };
			instrucaoBIOS[21] <= { 6'd6, 5'd12, 5'd1, 5'd2, 11'd0 };
			instrucaoBIOS[22] <= { 6'd22, 5'd12, 5'd0, 16'd40 };
			instrucaoBIOS[23] <= { 6'd16, 5'd1, 16'd0, 5'd0 };
			instrucaoBIOS[24] <= { 6'd16, 5'd2, 16'd3, 5'd0 };
			instrucaoBIOS[25] <= { 6'd16, 5'd3, 16'd4, 5'd0 };
			instrucaoBIOS[26] <= { 6'd32, 5'd1, 5'd2, 5'd3, 11'd0 };
			instrucaoBIOS[27] <= { 6'd16, 5'd1, 16'd3, 5'd0 };
			instrucaoBIOS[28] <= { 6'd18, 5'd2, 16'd1, 5'd0 };
			instrucaoBIOS[29] <= { 6'd0, 5'd13, 5'd1, 5'd2, 11'd0 };
			instrucaoBIOS[30] <= { 6'd17, 5'd13, 16'd3, 5'd0 };
			instrucaoBIOS[31] <= { 6'd16, 5'd1, 16'd4, 5'd0 };
			instrucaoBIOS[32] <= { 6'd18, 5'd2, 16'd1, 5'd0 };
			instrucaoBIOS[33] <= { 6'd0, 5'd14, 5'd1, 5'd2, 11'd0 };
			instrucaoBIOS[34] <= { 6'd17, 5'd14, 16'd4, 5'd0 };
			instrucaoBIOS[35] <= { 6'd16, 5'd1, 16'd2, 5'd0 };
			instrucaoBIOS[36] <= { 6'd18, 5'd2, 16'd1, 5'd0 };
			instrucaoBIOS[37] <= { 6'd0, 5'd15, 5'd1, 5'd2, 11'd0 };
			instrucaoBIOS[38] <= { 6'd17, 5'd15, 16'd2, 5'd0 };
			instrucaoBIOS[39] <= { 6'd26, 16'd19, 10'd0 };
			instrucaoBIOS[40] <= { 6'd16, 5'd1, 16'd6, 5'd0 };
			instrucaoBIOS[41] <= { 6'd31, 5'd1, 21'd0 };
			instrucaoBIOS[42] <= { 6'd16, 5'd1, 16'd7, 5'd0 };
			instrucaoBIOS[43] <= { 6'd18, 5'd2, 16'd15, 5'd0 };
			instrucaoBIOS[44] <= { 6'd11, 5'd16, 5'd1, 5'd2, 11'd0 };
			instrucaoBIOS[45] <= { 6'd22, 5'd16, 5'd0, 16'd50 };
			instrucaoBIOS[46] <= { 6'd18, 5'd1, 16'd0, 5'd0 };
			instrucaoBIOS[47] <= { 6'd31, 5'd1, 21'd0 };
			instrucaoBIOS[48] <= { 6'd35, 26'd0 };
			instrucaoBIOS[49] <= { 6'd26, 16'd52, 10'd0 };
			instrucaoBIOS[50] <= { 6'd16, 5'd1, 16'd7, 5'd0 };
			instrucaoBIOS[51] <= { 6'd31, 5'd1, 21'd0 };
			instrucaoBIOS[52] <= { 6'd29, 26'd0 };



	
				
			start <= 0;
		end		
	end
	

	
	
endmodule