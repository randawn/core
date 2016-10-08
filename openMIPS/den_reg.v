module den_reg
    #(parameter WIDTH=1)
(
    input clk,
    input en,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (en) begin
        q <= #1 d;
    end
end

endmodule

