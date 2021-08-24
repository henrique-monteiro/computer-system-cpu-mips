module extensorBits(sinalUC, sinal16, sinal32);

	input sinalUC;
	input [15:0] sinal16;
	output reg [31:0] sinal32;

	always@(*) begin
		sinal32 = 0;
		if (sinalUC) begin
			if (sinal16[15] == 1)
				sinal32 = sinal16 + 32'b11111111111111110000000000000000;
			else
				sinal32 = {16'd0, sinal16};
		end
	end	
endmodule
