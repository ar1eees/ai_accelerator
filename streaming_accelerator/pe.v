module pe (
    input clk, en,
    input      [7:0] a, b,
    output reg [15:0] out
);
    
    always @(posedge clk) begin
        if (en) begin
            out <= a*b;
        end else begin // return zero if not eneable for now
            out <= 0;
        end
    end
    
endmodule