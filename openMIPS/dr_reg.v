module dr_reg
    #(parameter WIDTH=1)
(
    input clk,
    input rst_,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (!rst_) begin
        q <= #1 'b0;
    end else begin
        q <= #1 d;
    end
end

endmodule

