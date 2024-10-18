module buffer #(
    parameter DataWidth = 8,
    parameter BuffDepth = 256,
    parameter AddrWidth = $clog2(BuffDepth)
) (
    input                      clk, write_en, read_en,
    input      [DataWidth-1:0] data_in, 
    input      [AddrWidth-1:0] addr,
    output reg [DataWidth-1:0] data_out
);
    reg [DataWidth-1:0] buffer [0:BuffDepth-1];

    always @(posedge clk) begin
        if (read_en && !write_en) begin
            data_out <= buffer[addr];
        end else if (write_en && !read_en) begin
            buffer[addr] <= data_in;
        end
    end

endmodule