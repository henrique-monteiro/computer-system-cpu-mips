module Display(sinalSaida, entrada, saida);

	input sinalSaida;
	input [3:0] entrada;
	output reg [6:0] saida;
	
	always @(*) begin
		if (sinalSaida)
		case (entrada)
			0: saida = 7'b0000001; //1
			1: saida = 7'b1001111; //79
			2: saida = 7'b0010010; //18
			3: saida = 7'b0000110; //6
			4: saida = 7'b1001100; //76
			5: saida = 7'b0100100; //36
			6: saida = 7'b0100000; //32
			7: saida = 7'b0001101; //13
			8: saida = 7'b0000000; //0
			9: saida = 7'b0000100; //4
			10: saida = 7'b1111110;
			default: saida = 7'b1111111;
		endcase
		
		else
			saida = 7'b1111111;
	end
endmodule
