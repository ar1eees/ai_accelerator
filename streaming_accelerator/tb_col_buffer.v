
module tb_col_buffer;
reg clk, nrst, start;
reg  [ 63:0] data_in;
wire [191:0] mapping;
wire [  7:0] valid;

col_buffer uut (
    .clk (clk),
    .nrst(nrst),
    .start(start),
    .data_in(data_in),
    .mapping(mapping),
    .valid(valid)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb.vcd");
    $dumpvars;

    clk = 0;
    nrst = 0;
    start = 0;
    data_in = 0;

    #10 nrst = 1;
    #(10*3);

    start = 1;
    data_in = 64'h0706050403020100;

    #(10);

    start = 0;
    data_in = 64'h0f0e0d0c0b0a0908;

    #(10);

    data_in = 64'hdeadbeefb055ade1;
    

    $finish;
end

endmodule