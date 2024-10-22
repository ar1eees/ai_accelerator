module cu_engine (
    input  clk, nrst,
    input  [ 71:0] filter, 
    input  [ 23:0] data_in,
    input  [  8:0] pe_en_ctrl,
    output [143:0] pe_out
);
    reg [23:0] dff [0:1];

    pe pe00 (.clk(clk), .en(pe_en_ctrl[0]), .a(data_in[ 7: 0]), .b(filter[ 7: 0]), .out(pe_out[15: 0]));
    pe pe10 (.clk(clk), .en(pe_en_ctrl[1]), .a(data_in[15: 8]), .b(filter[15: 8]), .out(pe_out[31:16]));
    pe pe20 (.clk(clk), .en(pe_en_ctrl[2]), .a(data_in[23:16]), .b(filter[23:16]), .out(pe_out[47:32]));

    pe pe01 (.clk(clk), .en(pe_en_ctrl[3]), .a(dff[0][ 7: 0]), .b(filter[31:24]), .out(pe_out[63:48]));
    pe pe11 (.clk(clk), .en(pe_en_ctrl[4]), .a(dff[0][15: 8]), .b(filter[39:32]), .out(pe_out[79:64]));
    pe pe21 (.clk(clk), .en(pe_en_ctrl[5]), .a(dff[0][23:16]), .b(filter[47:40]), .out(pe_out[95:80]));

    pe pe02 (.clk(clk), .en(pe_en_ctrl[6]), .a(dff[1][ 7: 0]), .b(filter[55:48]), .out(pe_out[111: 96]));
    pe pe12 (.clk(clk), .en(pe_en_ctrl[7]), .a(dff[1][15: 8]), .b(filter[63:56]), .out(pe_out[127:112]));
    pe pe22 (.clk(clk), .en(pe_en_ctrl[8]), .a(dff[1][23:16]), .b(filter[71:64]), .out(pe_out[143:128]));

    always @(posedge clk) begin
        if (!nrst) begin
            dff[0] <= 0;
            dff[1] <= 0;
        end else begin
            dff[0] <= data_in;
            dff[1] <= dff[0]; 
        end
    end
    
endmodule