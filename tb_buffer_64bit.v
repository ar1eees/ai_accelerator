`timescale 1ns/1ps

module tb_buffer_64bit;

parameter BuffDepth = 128;
parameter ByteAddrW = $clog2(BuffDepth);
parameter WordAddrW = $clog2(BuffDepth/8);

reg clk, write_en, read_en, addr_mode;
reg [ByteAddrW-1:0] byte_addr;
reg [WordAddrW-1:0] word_addr;
reg [ 7:0] byte_in;
reg [63:0] word_in;

wire [ 7:0] byte_out;
wire [63:0] word_out;

buffer_64bit #(
    .BuffDepth(BuffDepth)
) uut (
    .clk(clk),
    .write_en(write_en),
    .read_en(read_en),
    .addr_mode(addr_mode),
    .byte_addr(byte_addr),
    .word_addr(word_addr),
    .byte_in(byte_in),
    .word_in(word_in),
    .byte_out(byte_out),
    .word_out(word_out)
);

initial begin
    $dumpfile("tb.vcd");
    $dumpvars;

    clk = 0;
    write_en  = 0;
    read_en   = 0;
    addr_mode = 0;
    byte_addr = 0;
    word_addr = 0;
    byte_in   = 0;

    #(10*5);




    $finish;
end

endmodule