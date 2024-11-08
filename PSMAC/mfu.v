module HA ( input  a, b, output s, c );
    assign s = a ^ b;
    assign c = a & b;
endmodule

module FA ( input  a, b, ci, output s, co );
    assign s  = (a ^ b) ^ ci;
    assign co = (a & b) | (b & ci) | (ci & a);
endmodule

module mul_ss (
    input  [1:0] a, b,
    output [3:0] p
);
    // signed x signed
    wire [1:0] pp0, pp1;
    // partial product
    assign pp0 = { ~(a[1] & b[0]), (a[0] & b[0]) };
    assign pp1 = { (a[1] & b[1]), ~(a[0] & b[1]) };
    // p0
    assign p[0] = pp0[0];
    // p1
    wire HA_p1_co;
    HA HA_p1(.a(pp0[1]), .b(pp1[0]), .s(p[1]), .c(HA_p1_co));
    // p2 + 1'b1
    wire FA_p2_co;
    FA FA_p2(.a(pp1[1]), .b(1'b1), .ci(HA_p1_co), .s(p[2]), .co(FA_p2_co));
    // simplified exp for P3
    assign p[3] = FA_p2_co ^ 1'b1;
endmodule

module mul_uu (
    input  [1:0] a, b,
    output [3:0] p
);
    // unsigned x unsigned
    wire [1:0] pp0, pp1;
    // partial product
    assign pp0 = { (a[1] & b[0]), (a[0] & b[0]) };
    assign pp1 = { (a[1] & b[1]), (a[0] & b[1]) };
    // p0
    assign p[0] = pp0[0];
    // p1
    wire HA_p1_co;
    HA HA_p1(.a(pp0[1]), .b(pp1[0]), .s(p[1]), .c(HA_p1_co));
    // p2 and p3
    HA HA_p2(.a(pp1[1]), .b(HA_p1_co), .s(p[2]), .c(p[3]));
endmodule

module mfu (
    input      [1:0] a, b, sel, // sel = {is_signed(a),is_signed(b)}
    output reg [3:0] p
);

    wire [1:0] ai, bi;

    localparam UU = 2'b00; // unsigned x unsigned
    localparam US = 2'b01; // unsigned x signed
    localparam SU = 2'b10; // signed x unsigned
    localparam SS = 2'b11; // signed x signed

    assign ai = (sel==US)? b : a;
    assign bi = (sel==US)? a : b; 

    wire [3:0] p_ss, p_uu, p_su;
    mul_ss ss(.a(ai), .b(bi), .p(p_ss));
    mul_uu uu(.a(ai), .b(bi), .p(p_uu));
    assign p_su = (~bi[1])? p_ss : {(p_ss[3] ^ ai[1]) ^ (p_ss[2] & ai[0]), (p_ss[2] ^ ai[0]), p_ss[1:0]};

    always @(*) begin
        case (sel)
            UU:     p <= p_uu;
            US, SU: p <= p_su;
            SS:     p <= p_ss;
        endcase        
    end
endmodule