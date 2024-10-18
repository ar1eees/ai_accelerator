// Byte addressable buffer with 64bit word loading capability

module buffer_64bit #(
    parameter BuffDepth = 256,
    parameter ByteAddrW = $clog2(BuffDepth),
    parameter WordDepth = BuffDepth/8,
    parameter WordAddrW = $clog2(WordDepth)
) (
    input  clk,
    input  write_en, read_en,
    input  addr_mode,                    // 0 - byte mode, 1 - word mode
    input  [ByteAddrW-1:0] byte_addr,
    input  [WordAddrW-1:0] word_addr,
    input  [ 7:0] byte_in,
    input  [63:0] word_in,
    output reg [ 7:0] byte_out,
    output reg [63:0] word_out
);
    reg [63:0] buffer [0:WordDepth-1];

/**************** LOAD MEMORY FILE ****************/
    localparam FN = "../buffer.mem";
    integer file;
    initial begin


        file = $fopen(FN, "r");

        if (file != 0) begin
            $readmemh(FN, buffer);
        end else begin
            $display("Error: Could not open file!");
            $stop;
        end
    end
/**************************************************/

    wire [WordAddrW-1:0] addr;
    reg  [63:0] data_in;

    assign addr = (addr_mode)? word_addr : {byte_addr[ByteAddrW-1:3]};

    always @(*) begin
        if (addr_mode) begin
            data_in = word_in;
        end else begin
            case (byte_addr[2:0])
                3'd0:    data_in = {buffer[addr][63: 8],byte_in};
                3'd1:    data_in = {buffer[addr][63:16],byte_in,buffer[addr][ 7:0]};
                3'd2:    data_in = {buffer[addr][63:24],byte_in,buffer[addr][15:0]};
                3'd3:    data_in = {buffer[addr][63:32],byte_in,buffer[addr][23:0]};
                3'd4:    data_in = {buffer[addr][63:40],byte_in,buffer[addr][31:0]};
                3'd5:    data_in = {buffer[addr][63:48],byte_in,buffer[addr][39:0]};
                3'd6:    data_in = {buffer[addr][63:56],byte_in,buffer[addr][47:0]};
                default: data_in = {byte_in,buffer[addr][55:0]};
            endcase
        end
    end

    always @(*) begin
        case (byte_addr[2:0])
            3'd0:    byte_out = word_out[ 7: 0];
            3'd1:    byte_out = word_out[15: 8];
            3'd2:    byte_out = word_out[23:16];
            3'd3:    byte_out = word_out[31:24];
            3'd4:    byte_out = word_out[39:32];
            3'd5:    byte_out = word_out[47:40];
            3'd6:    byte_out = word_out[55:48];
            default: byte_out = word_out[63:56];
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