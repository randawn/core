module d_reg
    #(parameter WIDTH=1)
(
    input clk,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    q <= #1 d;
end

endmodule

