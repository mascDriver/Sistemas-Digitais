`include "registrador.v"
`include "mux.v"
`include "multiplicador_somador.v"

module bo(
    input clock,
    input LX,
    input [1:0] M0,
    input [1:0] M1,
    input [1:0] M2,
    input H,
    input LS,
    input LH,
    input  [7:0] valor_x,
    input  [15:0] valor_a,
    input  [15:0] valor_b,
    input  [15:0] valor_c,
    output  [15:0] resultado
);
    wire  [15:0] valor_x16;
    assign valor_x16 = valor_x;
    wire  [15:0] out_x;
    wire  [15:0] out_s;
    wire  [15:0] out_h;
    wire  [15:0] out_mux0;
    wire  [15:0] out_mux1;
    wire  [15:0] out_mux2;
    wire  [15:0] out_ula;

    registrador reg_x(clock, LX, valor_x16, out_x);
    registrador reg_s(clock, LS, out_ula, out_s);
    registrador reg_h(clock, LH, out_ula, out_h);

    mux mux0(valor_a,valor_a,valor_b,valor_c,M0,out_mux0);
    mux mux1(out_mux0,out_x,out_s, out_h, M1, out_mux1);
    mux mux2(out_x, out_mux0, out_s, out_h, M2, out_mux2);

    multiplicador_somador multiplicador_somador0(out_mux1, out_mux2, H, out_ula);

    assign resultado = out_s;

endmodule

module bc(
    input clock,
    input reset,
    input enable,
    output LX,
    output [1:0] M0,
    output [1:0] M1,
    output [1:0] M2,
    output H,
    output LS,
    output LH,
    output done,
    output ready
);
    reg[3:0] state;

    always @(posedge clock or reset) begin

        if (reset)
            state <= 0;

        else begin
            if (state == 0 && ~enable)
                state <= state;
            else begin
                if(state == 8)
                    state <= 0;
                else begin
                state <= state + 1;
                end
            end
        end
    end

    assign M0 = state == 0? 0 : state == 3? 1 : state == 4? 2 : state == 6? 3 : 0;

    assign M1 = state == 2? 1 : state == 3? 0 :  state == 5? 2 : state == 6? 0 : 0;

    assign M2 = state == 2? 0 : state == 3? 2 :  state == 5? 3 : state == 6? 3 : 0;

    assign H = state == 2? 1 : state == 3? 1 : state == 4? 1 : 0;

    assign LX = state == 1? 1 : 0;

    assign LS = state == 2? 1 : state == 4? 1 : state == 6? 1 : 0;

    assign LH = state == 3? 1 : state == 5? 1 : 0;

    assign done = state == 0? 0 : state == 1? 0 : state == 2? 0 : state == 3? 0 : state == 4? 0 : state == 5? 0 : state == 6? 0 : state == 7? 1 : 0;

    assign ready = state == 0? 1 : state == 1? 0 : state == 2? 0 : state == 3? 0 : state == 4? 0 : state == 5? 0 : state == 6? 0 : state == 7? 0 : 0;

endmodule
