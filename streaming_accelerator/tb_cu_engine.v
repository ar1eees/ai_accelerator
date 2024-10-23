
module tb_cu_engine;
reg  clk, nrst;
reg  [71:0] filter;
reg  [23:0] data_in;
reg  [ 8:0] pe_en_ctrl;
wire [15:0] pe_out;

cu_engine uut(
    .clk (clk),
    .nrst(nrst),
    .filter(filter),
    .data_in(data_in),
    .pe_en_ctrl(pe_en_ctrl),
    .pe_out(pe_out)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb.vcd");
    $dumpvars;

    clk = 0;
    nrst = 0;
    filter  = 0;
    data_in = 0;
    pe_en_ctrl = 0;

    #10 nrst = 1;
    filter  = 72'h010000000100000001;
    
    #(10*3);
    
    data_in = 64'h0706050403020100;
    pe_en_ctrl = 9'b000000111;

    #(10);
    
    data_in = 64'h0f0e0d0c0b0a0908;
    pe_en_ctrl = 9'b000111111;

    #(10);

    data_in = 64'hdeadbeefb055ade1;
    pe_en_ctrl = 9'b111111111;
    
    #(10*3);

    $finish;
end

endmodule