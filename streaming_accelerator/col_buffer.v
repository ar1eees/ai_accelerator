module col_buffer #(
    parameter RowBufSize = 256,
    parameter RowBufAddrW = $clog2(RowBufSize)
) (
    input  clk, nrst, route_en, start,
    input  [RowBufAddrW-1:0] col_size,
    input  [ 63:0] data_in,
    output reg row_done,
    output [  7:0] valid,
    output [191:0] mapping
);
    reg [RowBufAddrW-1:0] max_count; // count of columns before changing rows

    reg [7:0] row_buff [0:1][0:RowBufSize-1];
    reg [RowBufAddrW:0] count;    // counter for row_buff index

    reg [23:0] temp_map [0:7];

    reg [7:0] valid;

    // FSM states
    localparam IDLE  = 2'b00;
    localparam ROUTE = 2'b01;
    localparam WAIT  = 2'b10; // it takes one cc to propagate data
    localparam DONE  = 2'b11;
    // router FSM
    reg [1:0] state;
    always @(posedge clk) begin
        if (!nrst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:    state <= (route_en)? ROUTE : IDLE;
                ROUTE:   state <= WAIT;
                WAIT:    state <= (count < max_count)? ROUTE : DONE;
                default: state <= IDLE;
            endcase
        end
    end

    integer i;
    always @(posedge clk) begin
        if (!nrst) begin
            valid <= 0;
            row_done <= 0;
            max_count <= 0;
            count <= 0;
            for (i=0; i<RowBufSize; i=i+1) begin
                row_buff[0][i] <= 8'b0;
                row_buff[1][i] <= 8'b0;
            end
            for (i=0; i<8; i=i+1) begin
                temp_map[i] <= 23'b0;
            end
        end else begin
            case (state)
                IDLE: begin
                    if (route_en) begin
                        valid <= 0;
                        row_done <= 0;
                        max_count <= (col_size < RowBufSize)? col_size : RowBufSize;
                        count <= 0;
                    end

                    for (i=0; i<8; i=i+1) begin
                        temp_map[i] <= 23'b0;
                    end
                end
                ROUTE: begin
                    if (!start) begin
                        temp_map[0] <= {
                            data_in[ 7:0],
                            row_buff[0][count],
                            row_buff[1][count]
                        };
                        temp_map[1] <= {
                            data_in[15:0],
                            row_buff[1][count]
                        };
                    end
                    temp_map[2] <= data_in[23: 0];
                    temp_map[3] <= data_in[31: 8];
                    temp_map[4] <= data_in[39:16];
                    temp_map[5] <= data_in[47:24];
                    temp_map[6] <= data_in[55:32];
                    temp_map[7] <= data_in[63:40];

                    row_buff[0][count] <= data_in[55:48];
                    row_buff[1][count] <= data_in[63:56];

                    valid <= (start)? 8'hFC: 8'hFF;
                    count <= count + 1;
                end
                WAIT: begin
                    if (count >= max_count) begin
                        row_done <= 1;
                    end
                    valid <= 0;
                end
                default: begin

                end
            endcase
        end
    end

    wire [7:0] r6,r7;
    assign r6 = row_buff[0][count];
    assign r7 = row_buff[1][count];

    assign mapping[ 23:  0] = temp_map[0];
    assign mapping[ 47: 24] = temp_map[1];
    assign mapping[ 71: 48] = temp_map[2];
    assign mapping[ 95: 72] = temp_map[3];
    assign mapping[119: 96] = temp_map[4];
    assign mapping[143:120] = temp_map[5];
    assign mapping[167:144] = temp_map[6];
    assign mapping[191:168] = temp_map[7];

endmodule