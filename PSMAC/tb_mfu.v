module tb_mfu;
reg  clk;
reg  [1:0] a, b, sel;
wire [3:0] p;

mfu uut(
    .a(a),
    .b(b),
    .sel(sel),
    .p(p)
);

always #5 clk=~clk;

integer i;
initial begin
    $dumpfile("tb.vcd");
    $dumpvars;

    clk = 0;
    a = 0;
    b = 0;
    sel = 2'b01;

    #10;

    for(i=0; i<16; i=i+1) begin
        a = i[1:0];
        b = i[3:2];
        #10;
    end

    $finish;
end

endmodule