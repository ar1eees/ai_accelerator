
module tb_col_buffer;

parameter RowBufSize = 256;
parameter RowBufAddrW = $clog2(RowBufSize);

reg clk, nrst, route_en, start;
reg  [RowBufAddrW-1:0] col_size;
reg  [ 63:0] data_in;
wire row_done;
wire [191:0] mapping;
wire [  7:0] valid;

col_buffer #(
    .RowBufSize(RowBufSize)
) uut (
    .clk (clk),
    .nrst(nrst),
    .route_en(route_en),
    .start(start),
    .col_size(col_size),
    .data_in(data_in),
    .row_done(row_done),
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
    route_en = 0;
    col_size = 0;
    data_in = 0;

    #10 nrst = 1; 
    #5;
    #(10*2);

    start = 1;
    route_en = 1;
    col_size = 3;
    data_in = 64'h0706050403020100;

    #(10*2);

    data_in = 64'h0f0e0d0c0b0a0908;

    #(10*2);

    data_in = 64'hdeadbeefb055ade1;
    
    #(10*2);
    
    start = 0;
    route_en = 0;
    data_in = 64'h0000000000000000;

    #(10*10)

    $finish;
end

endmodule