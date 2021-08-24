module geradorTick(	input clock50M, reset,
							input [31:0] baudrate,
							output tick);

	reg [31:0] contadorClock50M; // Contador de clock (conta até rate = 27, pois 50M / (16 * 115200))
	wire [31:0] Rate; // Divisor para baudrate

	assign Rate = 50000000 / (16 * baudrate);

	always @(posedge clock50M or negedge reset)
	begin
		if (!reset)		
			contadorClock50M <= 32'd1;		
	
		else if (tick)		
			contadorClock50M <= 32'd1;		
		
		else		
			contadorClock50M <= contadorClock50M + 32'd1;		
	end
	
	assign tick = (contadorClock50M == Rate);
	
endmodule


