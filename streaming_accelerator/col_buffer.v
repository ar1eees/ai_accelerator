module col_buffer #(
    parameter RowBufSize = 16
) (
    input clk, nrst,
    input  [ 63:0] data_in,
    output [  7:0] valid,
    output [191:0] mapping
);
    reg start;
    reg [ 7:0] row_buff [0:1];
    reg [23:0] temp_map [0:7];


    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            start <= 1;
            row_buff[0] <= 8'b0;
            row_buff[1] <= 8'b0;
        end else begin
            temp_map[0] <= {data_in[ 7: 0],row_buff[1],row_buff[0]};
            temp_map[1] <= {data_in[15: 0],row_buff[1]};
            temp_map[2] <= data_in[23: 0];
            temp_map[3] <= data_in[31: 8];
            temp_map[4] <= data_in[39:16];
            temp_map[5] <= data_in[47:24];
            temp_map[6] <= data_in[55:32];
            temp_map[7] <= data_in[63:40];

            row_buff[0] <= data_in[55:48];
            row_buff[1] <= data_in[63:56];

        end
    end
    
    assign valid = (start)? 8'hFC: 8'hFF;

    assign mapping[ 23:  0] = temp_map[0];
    assign mapping[ 47: 24] = temp_map[1];
    assign mapping[ 71: 48] = temp_map[2];
    assign mapping[ 95: 72] = temp_map[3];
    assign mapping[119: 96] = temp_map[4];
    assign mapping[143:120] = temp_map[5];
    assign mapping[167:144] = temp_map[6];
    assign mapping[191:168] = temp_map[7];
    
endmodule