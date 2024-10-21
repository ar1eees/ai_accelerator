`include "col_buffer.v"
`default_nettype none

module tb_col_buffer;
reg clk, nrst;
reg  [ 63:0] data_in;
wire [191:0] mapping;
wire [  7:0] valid;

col_buffer 
(
    .clk (clk),
    .nrst(nrst),
    .data_in(data_in),
    .mapping(mapping),
    .valid(valid)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_col_buffer.vcd");
    $dumpvars(0, tb_col_buffer);
end

initial begin
    #1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*3) rst_n<=1;
    #(CLK_PERIOD*3) rst_n<=0;clk<=0;
    repeat(5) @(posedge clk);
    rst_n<=1;
    @(posedge clk);
    repeat(2) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire