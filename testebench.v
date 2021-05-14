`include "bo_bc.v"

module ula(
    input clock,
    input  [7:0] valor_x,
    input  [15:0] valor_a,
    input  [15:0] valor_b,
    input  [15:0] valor_c,
    input enable,
    input reset,
    output  [15:0] result,
    output ready,
    output valid
);
    wire LX;
    wire [1:0] M0;
    wire [1:0] M1;
    wire [1:0] M2;
    wire H;
    wire LS;
    wire LH;

    bc bc0(clock, reset, enable, LX, M0, M1, M2, H, LS, LH, valid, ready);
    bo bo0(clock, LX, M0, M1, M2, H, LS, LH, valor_x, valor_a, valor_b, valor_c, result);

endmodule

module testbench;

	reg  [7:0] x = 3;
	reg  [15:0] a = 3;
	reg  [15:0] b = 3;
	reg  [15:0] c = 3;
	wire  [15:0] resultado;

	reg clock = 0, enable = 0, reset = 0;

	wire valid, ready;


	ula ula0(clock, x, a, b, c, enable, reset, resultado, ready, valid);

	always #1 clock <= ~clock;


	initial begin
	    $dumpvars;
	    
	    reset <= 1;

	    #1;

	    reset <= 0;
	    enable <= 1;

	    #13
	    $finish;
	end

endmodule
