// Byte addressable buffer with 64bit word loading capability

module buffer_64bit #(
    parameter BuffDepth = 256,
    parameter ByteAddrW = $clog2(BuffDepth),
    parameter WordAddrW = $clog2(BuffDepth/8)
) (
    input  clk,
    input  write_en, read_en,
    input  addr_mode,                    // 0 - byte mode, 1 - word mode
    input  [ByteAddrW-1:0] byte_addr,
    input  [WordAddrW-1:0] word_addr,
    input  [ 7:0] byte_in,
    input  [63:0] word_in,
    output [ 7:0] byte_out,
    output reg [63:0] word_out
);
    reg [7:0] buffer [0:WordAddrW-1];

/**************** LOAD MEMORY FILE ****************/
    integer file, scan, i;
    initial begin

        localparam FN = "buffer.mem";

        file = $fopen(FN, "r");

        if (file != 0) begin
            $display("Loading %s",FN);
            $readmemh(FN, buffer);
        end else begin
            $display("Error: Could not open file!");
            $stop;
        end
    end
/**************************************************/

    wire [WordAddrW-1:0] addr;
    wire [63:0] data_in;

    assign addr = (addr_mode)? {byte_addr[ByteAddrW-1:3]} : word_addr;

    always @(*) begin
        if (addr_mode) begin
            data_in = word_in;
        end else begin
            case (byte_in[2:0])
                3'd0:    data_in = {56'd0,byte_in};
                3'd1:    data_in = {byte_in, 8'd0};
                3'd2:    data_in = {byte_in,16'd0};
                3'd3:    data_in = {byte_in,24'd0};
                3'd4:    data_in = {byte_in,32'd0};
                3'd5:    data_in = {byte_in,40'd0};
                3'd6:    data_in = {byte_in,48'd0};
                default: data_in = {byte_in,56'd0};
            endcase
        end
    end
    
    always @(*) begin
        case (byte_in[2:0])
            3'd0:    byte_out = word_out[ 7:0];
            3'd1:    byte_out = word_out[15:0];
            3'd2:    byte_out = word_out[23:0];
            3'd3:    byte_out = word_out[31:0];
            3'd4:    byte_out = word_out[39:0];
            3'd5:    byte_out = word_out[47:0];
            3'd6:    byte_out = word_out[55:0];
            default: byte_out = word_out[63:0];
        endcase
    end

    always @(posedge clk) begin
        if (read_en && !write_en) begin
            word_out <= buffer[addr];
        end else if (write_en && !read_en) begin
            buffer[addr] <= data_in;
        end
    end

endmodule